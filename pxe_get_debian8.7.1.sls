{% set basepath = '/srv/tftp' %}

/srv/tftp/sysimages/debian-8.7.1-i386-amd64-source-DVD-1/debian-8.7.1-i386-amd64-source-DVD-1.iso:
  file.managed:
    - source: http://cdimage.debian.org/debian-cd/current/multi-arch/iso-dvd/debian-8.7.1-i386-amd64-source-DVD-1.iso
    - source_hash: http://cdimage.debian.org/debian-cd/current/multi-arch/iso-dvd/SHA256SUMS
    - user: root
    - group: root

/mnt/debian-8.7.1-i386-amd64-source-DVD-1_iso:
  mount.mounted:
    - device: {{ basepath }}/sysimages/debian-8.7.1-i386-amd64-source-DVD-1/debian-8.7.1-i386-amd64-source-DVD-1.iso
    - fstype: iso9660
    - mkmnt: True
    - opts:
      - defaults

cp -rf /mnt/debian-8.7.1-i386-amd64-source-DVD-1_iso/* {{ basepath }}/sysimages/debian-8.7.1-i386-amd64-source-DVD-1_iso/.:
  cmd.run

ubuntu_dir_create:
  file.directory:
    - name: {{ basepath }}/sysimages/debian-8.7.1-i386-amd64-source-DVD-1/
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
      - mode

{{ basepath }}/sysimages/debian-8.7.1-i386-amd64-source-DVD-1:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True


{{ basepath }}/pxelinux.cfg/default:
  file.blockreplace:
    - marker_start: "# START debian-8.7.1-i386-amd64-source-DVD-1"
    - marker_end: "# END debian-8.7.1-i386-amd64-source-DVD-1"
    - show_changes: True
    - append_if_not_found: True
    - content: |
        LABEL      debian-8.7.1-i386-amd64-source-DVD-1
        MENU LABEL ^debian 8.7.1 i386 amd64 source DVD1
        KERNEL     sysimages/debian-8.7.1-i386-amd64-source-DVD-1/casper/vmlinuz.efi
        APPEND     root=/dev/nfs nfsroot=172.23.92.251:{{ basepath }}/sysimages/debian-8.7.1-i386-amd64-source-DVD-1 netboot=nfs ro file=/cdrom/sysimages/debian-8.7.1-i386-amd64-source-DVD-1/preseed/ubuntu.seed boot=casper initrd=/sysimages/debian-8.7.1-i386-amd64-source-DVD-1/casper/initrd.lz locale=de_DE bootkbd=de console-setup/layoutcode=de ip=dhcp -- 
 

