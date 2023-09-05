OVMF_FD?=/usr/share/ovmf/x64/OVMF.fd
disk?=disk
qemu?=qemu-system-x86_64 -net none
ovmf.fd:$(OVMF_FD);cp $< $@
uefi-shell:ovmf.fd;$(qemu) -bios $<
disk:$(disk);mkdir -p $(disk)
shell:ovmf.fd disk
