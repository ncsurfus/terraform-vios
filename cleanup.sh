terraform destroy -auto-approve
virsh undefine sw-1
virsh destroy nxos9-1
virsh destroy rtr-1
virsh destroy sw-1
virsh undefine nxos9-1
virsh undefine rtr-1
virsh undefine sw-1
virsh net-destroy vm_network
virsh net-undefine vm_network
virsh vol-delete nxos9 --pool default
virsh vol-delete nxos9-1 --pool default
virsh vol-delete rtr-1 --pool default
virsh vol-delete sw-1 --pool default
virsh vol-delete vios-l2 --pool default
virsh vol-delete vios-l3 --pool default
