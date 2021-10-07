function usage {
    echo "usage: bash acr-firewall-allow.sh [destroy|apply]"
    echo ""
    echo "To add web app public IP addresses to ACR firewall run:"
    echo "  bash acr-firewall-allow.sh apply"
    echo ""
    echo "To remove web app public IP addresses from ACR firewall run:"
    echo "  bash acr-firewall-allow.sh destroy"
    exit 1
}

if [ $# -ne 1 ]; then
   usage;
fi

ip_addresses=$(terraform output -raw webapp_ip_addresses | tr "," "\n")
acr_name=$(terraform output -raw acr_name)
acr_rg=$(terraform output -raw acr_rg)

case $1 in
  destroy)
    echo "Removing web app IP addresses from ACR"
    for ip in $ip_addresses
    do
      az acr network-rule remove -n $acr_name -g $acr_rg --ip-address $ip > /dev/null
    done
    exit 0
    ;;
  apply)
    echo "Adding web app IP addresses to ACR"
    for ip in $ip_addresses
    do
      az acr network-rule add -n $acr_name -g $acr_rg --ip-address $ip > /dev/null
    done
    exit 0
    ;;
  *)
    usage;
    exit 1
    ;;
esac
