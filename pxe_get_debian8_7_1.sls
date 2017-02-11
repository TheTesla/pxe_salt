{% set basepath = '/srv/tftp' %}

/srv/tftp/sysimages/debian-8.7.1-amd64-i386-netinst/debian-8.7.1-amd64-i386-netinst.iso:
  file.managed:
    - source: http://cdimage.debian.org/debian-cd/current/multi-arch/iso-cd/debian-8.7.1-amd64-i386-netinst.iso
    - source_hash: http://cdimage.debian.org/debian-cd/current/multi-arch/iso-cd/SHA256SUMS
    - user: root
    - group: root

/mnt/debian-8.7.1-amd64-i386-netinst.iso:
  mount.mounted:
    - device: {{ basepath }}/sysimages/debian-8.7.1-amd64-i386-netinst/debian-8.7.1-amd64-i386-netinst.iso
    - fstype: iso9660
    - mkmnt: True
    - opts:
      - defaults

cp -rf /mnt/debian-8.7.1-amd64-i386-netinst/* {{ basepath }}/sysimages/debian-8.7.1-amd64-i386-netinst/.:
  cmd.run

ubuntu_dir_create:
  file.directory:
    - name: {{ basepath }}/sysimages/debian-8.7.1-amd64-i386-netinst/
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
      - mode

{{ basepath }}/sysimages/debian-8.7.1-amd64-i386-netinst:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True


{{ basepath }}/pxelinux.cfg/default:
  file.blockreplace:
    - marker_start: "# START debian-8.7.1-amd64-i386-netinst"
    - marker_end: "# END debian-8.7.1-amd64-i386-netinst"
    - show_changes: True
    - append_if_not_found: True
    - content: |
        LABEL      debian-8.7.1-amd64-i386-netinst
        MENU LABEL ^debian-8.7.1 amd64 i386 netinst
        KERNEL     sysimages/debian-8.7.1-amd64-i386-netinst/casper/vmlinuz.efi
        APPEND     root=/dev/nfs nfsroot=172.23.92.251:{{ basepath }}/sysimages/debian-8.7.1-amd64-i386-netinst netboot=nfs ro file=/cdrom/sysimages/debian-8.7.1-amd64-i386-netinst/preseed/ubuntu.seed boot=casper initrd=/sysimages/debian-8.7.1-amd64-i386-netinst/casper/initrd.lz locale=de_DE bootkbd=de console-setup/layoutcode=de ip=dhcp -- 
 

