/srv/tftp/sysimages/ubuntu_16_04_1_destop_amd64/ubuntu-16.04.1-desktop-amd64.iso:
  file.managed:
    - source: http://releases.ubuntu.com/16.04/ubuntu-16.04.1-desktop-amd64.iso
    - source_hash: dc7dee086faabc9553d5ff8ff1b490a7f85c379f49de20c076f11fb6ac7c0f34
    - user: root
    - group: root

/mnt/ubuntu-16.04.1-desktop-amd64_iso:
  mount.mounted:
    - device: /srv/tftp/sysimages/ubuntu_16_04_1_destop_amd64/ubuntu-16.04.1-desktop-amd64.iso
    - fstype: iso9660
    - mkmnt: True
    - opts:
      - defaults

cp -rf /mnt/ubuntu-16.04.1-desktop-amd64_iso/* /srv/tftp/sysimages/ubuntu_16_04_1_destop_amd64/.:
  cmd.run

ubuntu_dir_create:
  file.directory:
    - name: /srv/tftp/sysimages/ubuntu_16_04_1_destop_amd64/
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
      - mode

/srv/tftp/bios/sysimages/ubuntu_16_04_1_destop_amd64:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True


/srv/tftp/bios/pxelinux.cfg/default:
  file.blockreplace:
    - marker_start: "# START ubuntu_16_04_1_destop_amd64"
    - marker_end: "# END ubuntu_16_04_1_destop_amd64"
    - show_changes: True
    - append_if_not_found: True
    - content: |
        LABEL      ubuntu16041amd64
        MENU LABEL ^Ubuntu 16.04.1 Live amd64
        KERNEL     sysimages/ubuntu_16_04_1_destop_amd64/casper/vmlinuz.efi
        APPEND     root=/dev/nfs nfsroot=172.23.92.251:/srv/tftp/sysimages/ubuntu_16_04_1_destop_amd64 netboot=nfs ro file=/cdrom/sysimages/ubuntu_16_04_1_destop_amd64/preseed/ubuntu.seed boot=casper initrd=/sysimages/ubuntu_16_04_1_destop_amd64/casper/initrd.lz locale=de_DE bootkbd=de console-setup/layoutcode=de ip=dhcp -- 
 
cp -afl /srv/tftp/sysimages/ubuntu_16_04_1_destop_amd64 /srv/tftp/bios/sysimages/.:
  cmd.run

