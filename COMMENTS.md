To make this change permanent

From a terminal (or after pressing Alt+F2) run:

> gksudo gedit /etc/default/grub

(or use sudo nano if gksudo or gedit are not available) and enter your password.

Find the line starting with GRUB_CMDLINE_LINUX_DEFAULT and append foo=bar to its end. For example:

> GRUB_CMDLINE_LINUX_DEFAULT="quiet splash foo=bar"

Save the file and close the editor.

Finally, start a terminal and run:

> sudo update-grub

Things to add as a kernel parameter :

> amdgpu.dcdebugmask=0x10

How to update grub :

> sudo update-grub (This does not work)

(hey are you okay)

> grub2-mkconfig -o /boot/grub2/grub.cfg

> /etc/grub2.cfg and /etc/grub2-efi.cfg are links to /boot/grub2/grub.cfg

> /boot/efi/EFI/fedora/grub.cfg is used to point to /boot/grub2/grub.cfg

> ref: https://fedoraproject.org/wiki/Changes/UnifyGrubConfig
