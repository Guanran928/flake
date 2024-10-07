import logging
import aiohttp
import random
import time
import os
from urllib.parse import urlparse
from telegram import Update, constants, InlineKeyboardMarkup, InlineKeyboardButton
from telegram.ext import ApplicationBuilder, ContextTypes, CommandHandler

logging.basicConfig(format="[%(levelname)s] %(message)s", level=logging.INFO)


class DanbooruFetcher:
    def __init__(self) -> None:
        self.session = None
        self.proxy = os.getenv("http_proxy")
        self.cache = {}
        self.cache_expiry = 3600  # 1 hour

    def _is_cache_valid(self, key: str) -> bool:
        return key in self.cache and (
            time.time() - self.cache[key]["timestamp"] < self.cache_expiry
        )

    async def create_session(self) -> None:
        if not self.session:
            self.session = aiohttp.ClientSession()

    async def fetch_danbooru(self, type: str) -> dict:
        await self.create_session()

        cache_key = f"danbooru_{type}"

        # Check if the data is already cached and valid
        if self._is_cache_valid(cache_key):
            logging.info(f"Returning cached data for type: {type}")
            return random.choice(self.cache[cache_key]["data"])

        # If not cached or expired, make a request
        logging.info(f"Fetching new data for type: {type}")
        async with self.session.get(
            url="https://danbooru.donmai.us/posts.json",
            params={
                "limit": 100,
                "tags": " ".join(
                    [
                        type,
                        "is:nsfw",
                        "order:rank",
                    ]
                ),
            },
            proxy=self.proxy,
        ) as response:
            response.raise_for_status()
            data = await response.json()

            # Cache the data with a timestamp
            self.cache[cache_key] = {
                "data": data,
                "timestamp": time.time(),
            }

            return random.choice(data)


fetcher = DanbooruFetcher()


def format_source(record: dict) -> str:
    if record["pixiv_id"] is not None:
        return f"https://www.pixiv.net/en/artworks/{record['pixiv_id']}"
    else:
        return record["source"]


def format_tags(tags: str) -> str:
    return tags.replace(" ", ", ").replace("_", " ")


def generate_caption(record: dict) -> str:
    return "\n".join(
        f"<pre><code class=\"language-{tag}\">{format_tags(record.get(f'tag_string_{tag}', '(no tag)'))}</code></pre>"
        for tag in ["character", "copyright", "artist"]
    )


def get_source_name(record: dict) -> str:
    source = record["source"]
    domain = urlparse(source).netloc
    if record["pixiv_id"] is not None:
        return "Pixiv"
    if any(
        domain.startswith(prefix)
        for prefix in [
            "twitter.com",
            "x.com",
            "fxtwitter.com",
            "fixupx.com",
            "vxtwitter.com",
        ]
    ):
        return "X (Twitter)"
    return domain


def get_reply_markup(r: dict) -> InlineKeyboardMarkup:
    return InlineKeyboardMarkup(
        [
            [
                InlineKeyboardButton(
                    text="Danbooru",
                    url=f"https://danbooru.donmai.us/posts/{r['id']}",
                ),
                InlineKeyboardButton(
                    text=get_source_name(r),
                    url=format_source(r),
                ),
            ],
        ]
    )


async def help(update: Update, _: ContextTypes.DEFAULT_TYPE) -> None:
    if update.message:
        await update.message.reply_text(
            do_quote=True,
            text="/help - get help\n/image - fetch image\n/video - fetch video",
        )


async def image(update: Update, _: ContextTypes.DEFAULT_TYPE) -> None:
    r = await fetcher.fetch_danbooru(type="-video")

    if update.message:
        try:
            await update.message.reply_photo(
                do_quote=True,
                photo=r["large_file_url"],
                parse_mode=constants.ParseMode.HTML,
                caption=generate_caption(r),
                reply_markup=get_reply_markup(r),
            )
        except Exception as e:
            logging.error(f"Error in /image: {e}")
            logging.error(f"{r['id']}, {r['file_url']}")
            await update.message.reply_text(
                do_quote=True,
                text=str(e),
            )


async def video(update: Update, _: ContextTypes.DEFAULT_TYPE) -> None:
    r = await fetcher.fetch_danbooru(type="video")

    if update.message:
        try:
            await update.message.reply_video(
                do_quote=True,
                video=r["large_file_url"],
                parse_mode=constants.ParseMode.HTML,
                caption=generate_caption(r),
                reply_markup=get_reply_markup(r),
            )
        except Exception as e:
            logging.error(f"Error in /video: {e}")
            logging.error(f"{r['id']}, {r['file_url']}")
            await update.message.reply_text(
                do_quote=True,
                text=str(e),
            )


if __name__ == "__main__":
    application = (
        ApplicationBuilder()
        .token(os.environ["DANBOORU_TELEGRAM_TOKEN"])
        .build()
    )

    application.add_handler(CommandHandler("help", help))
    application.add_handler(CommandHandler("image", image))
    application.add_handler(CommandHandler("video", video))

    application.run_polling()
