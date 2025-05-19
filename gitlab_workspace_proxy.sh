#!/bin/bash
export_values() {
    export CLIENT_ID="112233445566778899112233445566778899010022333344" # replace with you client_ID
    export CLIENT_SECRET="gloas-11223344556677889911223344556677889900" # replace with your client_Secret
    export REDIRECT_URI="https://workspaces.testdomain.com/auth/callback" # replace with your redirect_url
    export SIGNING_KEY="112233445566778899" # replace with your signing_key
    export GITLAB_URL="https://gitlab.testdomain.com" # replace with your gitlab_url
    export WORKSPACES_DOMAIN_CERT="/home/ubuntu/.certbot/config/live/workspaces.testdomain.com/fullchain.pem"  # replace with your certificates
    export WORKSPACES_DOMAIN_KEY="/home/ubuntu/.certbot/config/live/workspaces.testdomain.com/privkey.pem"  
    export WILDCARD_DOMAIN_CERT="/home/ubuntu/.certbot/config/live/workspaces.testdomain.com/fullchain.pem"
    export WILDCARD_DOMAIN_KEY="/home/ubuntu/.certbot/config/live/workspaces.testdomain.com/privkey.pem"
    export GITLAB_WORKSPACES_PROXY_DOMAIN="workspaces.testdomain.com"  # replace with your domain name
    export GITLAB_WORKSPACES_WILDCARD_DOMAIN="*.workspaces.testdomain.com" 
    export SSH_HOST_KEY=/home/ubuntu/ssh-host-key
}

workspace_proxy() {
    helm repo update
    # Installing helm chart
    helm upgrade --install gitlab-workspaces-proxy \
    gitlab-workspaces-proxy/gitlab-workspaces-proxy \
    --version ${VERSION} \
    --namespace=gitlab-workspaces \
    --create-namespace \
    --set="auth.client_id=${CLIENT_ID}" \
    --set="auth.client_secret=${CLIENT_SECRET}" \
    --set="auth.host=${GITLAB_URL}" \
    --set="auth.redirect_uri=${REDIRECT_URI}" \
    --set="auth.signing_key=${SIGNING_KEY}" \
    --set="ingress.host.workspaceDomain=${GITLAB_WORKSPACES_PROXY_DOMAIN}" \
    --set="ingress.host.wildcardDomain=${GITLAB_WORKSPACES_WILDCARD_DOMAIN}" \
    --set="ingress.tls.workspaceDomainCert=$(cat ${WORKSPACES_DOMAIN_CERT})" \
    --set="ingress.tls.workspaceDomainKey=$(cat ${WORKSPACES_DOMAIN_KEY})" \
    --set="ingress.tls.wildcardDomainCert=$(cat ${WILDCARD_DOMAIN_CERT})" \
    --set="ingress.tls.wildcardDomainKey=$(cat ${WILDCARD_DOMAIN_KEY})" \
    --set="ssh.host_key=$(cat ${SSH_HOST_KEY})" \
    --set="ingress.className=alb"

}

helm() {
    helm repo add gitlab-workspaces-proxy \
  https://gitlab.com/api/v4/projects/gitlab-org%2fworkspaces%2fgitlab-workspaces-proxy/packages/helm/devel

}


while true; do 
    # Display options
    echo "1) version 0.1.15"
    echo "2) Uninstall Gitlab Workspaces Proxy"
    echo "3) Exit"

    # Prompt to user
    read -p "Enter your choice: " choice

    case $choice in
        1)  
            (   
                VERSION="0.1.15"
                export_values
                helm
                workspace_proxy
                echo "Gitlab workspaces proxy setup completed."
            )
            ;;
        2)  
            helm uninstall gitlab-workspaces-proxy -n gitlab-workspaces
            ;;
        3)
            echo "Exiting..."
            break  
            ;;
        *)  
            echo "Invalid choice, try again." 
            ;;
    esac
done
