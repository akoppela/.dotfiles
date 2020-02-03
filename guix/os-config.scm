;; This is an operating system configuration template
;; for a "bare bones" setup, with no X11 display server.

(use-modules (gnu))
(use-service-modules networking ssh)

(operating-system
 (host-name "remote-dev")
 (timezone "Asia/Singapore")
 (locale "en_US.utf8")

 (bootloader (bootloader-configuration
              (bootloader grub-bootloader)
              (target "/dev/vda")))

 (swap-devices '("/dev/vda2"))

 (file-systems (cons (file-system
                      (device (file-system-label "guix"))
                      (mount-point "/")
                      (type "ext4"))
                     %base-file-systems))

 ;; Root user is implicit.
 (users (cons (user-account
               (name "akoppela")
               (comment "Andrey Koppel")
               (group "users")

               ;; Adding the account to the "wheel" group
               ;; makes it a sudoer.
               (supplementary-groups '("wheel")))
              %base-user-accounts))

 ;; Global packages
 (packages (cons glibc-utf8-locales git %base-packages))

 ;; DigitalOcean specifit configuration.
 ;; Have to investigate in the future.
 (initrd-modules (append (list "virtio_scsi")
                         %base-initrd-modules))

 ;; Add services to the baseline:
 ;; - a DHCP client and
 ;; - an SSH server.
 (services (append (list (service dhcp-client-service-type)
                         (service openssh-service-type
                                  (openssh-configuration
                                   (port-number 2222))))
                   %base-services)))
