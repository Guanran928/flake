{
  fileSystems."/persist" = {
    neededForBoot = true;
  };

  preservation = {
    enable = true;
    preserveAt."/persist".directories = [
      "/var"
      "/home"
    ];
  };
}
