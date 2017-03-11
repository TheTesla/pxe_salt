#!jinja|mako|yaml

{% set basepath = '/srv/tftp' %}
{% set version = '16.04.2' %}
{% set urlpath = 'http://releases.ubuntu.com/16.04' %}
{% set isoname = 'ubuntu-'+version+'-desktop-amd64.iso' %}
{% set sysdirname = 'ubuntu-'+version+'-desktop-amd64' %}
{% set labelname = 'Ubuntu Live '+version+' Desktop amd64' %}
{% set autoseed = 'ubuntu_16_04_1_destop_amd64_autoinstall_test.seed' %}

{{ basepath }}/sysimages/{{ sysdirname }}/{{ isoname }}:
  file.managed:
    - source: {{ urlpath }}/{{ isoname }}
    - source_hash: {{ urlpath }}/SHA256SUMS
    - makedirs: True
    - user: root
    - group: root

/mnt/{{ sysdirname }}:
  mount.mounted:
    - device: {{ basepath }}/sysimages/{{ sysdirname }}/{{ isoname }}
    - fstype: iso9660
    - mkmnt: True
    - opts:
      - defaults

cp -rf /mnt/{{ sysdirname }}/* {{ basepath }}/sysimages/{{ sysdirname }}/.:
  cmd.run



# create autoinstall preseed
{{ basepath }}/sysimages/{{ sysdirname }}/preseed/{{ autoseed }}:
  file.managed:
    - source: salt://{{ autoseed }}
    - user: root
    - group: root
    - mode: 755

{{ basepath }}/pxelinux.cfg/default:
  file.blockreplace:
    - marker_start: "# START {{ sysdirname }}"
    - marker_end: "# END {{ sysdirname }}"
    - show_changes: True
    - append_if_not_found: True
    - content: |
        LABEL      {{ sysdirname }}
        MENU LABEL ^{{ labelname }}
        KERNEL     sysimages/{{ sysdirname }}/casper/vmlinuz.efi
        APPEND     root=/dev/nfs nfsroot=172.23.92.251:{{ basepath }}/sysimages/{{ sysdirname }} netboot=nfs ro file=/cdrom/preseed/ubuntu.seed boot=casper initrd=/sysimages/{{ sysdirname }}/casper/initrd.lz locale=de_DE bootkbd=de console-setup/layoutcode=de ip=dhcp -- 
 
        LABEL      {{ sysdirname }}-autoinst
        MENU LABEL ^{{ labelname }} - AUTOINSTALL 
        KERNEL     sysimages/{{ sysdirname }}/casper/vmlinuz.efi
        APPEND     root=/dev/nfs nfsroot=172.23.92.251:{{ basepath }}/sysimages/{{ sysdirname }} netboot=nfs ro file=/cdrom/preseed/{{ autoseed }} boot=casper initrd=/sysimages/{{ sysdirname }}/casper/initrd.lz locale=de_DE bootkbd=de console-setup/layoutcode=de ip=dhcp dbg/flags=all-x auto -- 
