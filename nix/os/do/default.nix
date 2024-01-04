{
  imports = [
    ../default.nix
    ../config/networking.nix
    ./hardware.nix
  ];

  # Enable in-memory swap
  zramSwap.enable = true;

  # Keep temporary directory clean
  boot.cleanTmpDir = true;

  # Keep Nix store clean
  nix.settings.auto-optimise-store = true;

  # Default TCP ports
  networking.firewall.allowedTCPPorts = [
    22 # SSH
  ];

  # SSH keys
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDAoxj0XPpLF/NIvXdHJNjZqkylj/KDDtTp7J2yqB/owZAhl2oaxUT3t8fUTC67C8Y8Yv56nhwldtTJUEKdVy5522vO0JVgKYqXiI4UnSR7INgQxVPb8BMNXnIDjyTzOTTVaZ3yi5IWOxCYP0KYypt8tfvaTKoA74nHVjAlP/vTpE3cAfjNY8mSaLocfIUrS6H9f/xWF2y0DuQViOpvsZ4vUcz+4KSQetYlKiFpyhzZ+mRJ+NSS+nN7i1YZuEbLlNg7Q8rSPIcy+P5rTV4y8G+nsBBQrTgCh2BFdWWGaF4ZXLLvCQPdIqZNivj0OJC8CDrY+Zi5dtOgzKIF3eLlRbfgEENw5FWG3QyX8YuOst02+RIZwwqy/DsiwZ83Wy9PYHnMoZLgRf/NYj6vPM7IsPvy8sekFB+6cMab2R53254wl7YaK2+sqryZZ9kpCi24i+7Zj3dNsv12nZ+EoMrVmDN+EiL5+A/9TsbyA4CkQvDf0Ft/2m7ipXfB7GeyBkZh2xTiUS3JqKI8ohfn4Wm4fc2Q5VcceNyPegnY86daYQjaKRbq9bmr1AErB6VKsENE8bjyoPeVk+yJPtH6B/cxGLajcuERKyrWGh8tEM8EDU9+uyM4B/ENhPwiesxzROXuTzECG9YhfWoDAWamrtQBSPho+0d/sVGbMJX07nP/7l2HDw== akoppela@nano"
  ];
}
