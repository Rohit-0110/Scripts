#!/bin/bash

install_prometheus() {
    echo "Installing prometheus..."
    sudo wget https://github.com/prometheus/prometheus/releases/download/v2.45.0/prometheus-2.45.0.linux-amd64.tar.gz
    sudo tar -xzvf prometheus-2.45.0.linux-amd64.tar.gz -C /opt/
    echo "Installation completed."
}

install_node_exporter() {
    echo "Installing node exporter..."
    sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.6.0/node_exporter-1.6.0.linux-amd64.tar.gz
    sudo tar -xzvf node_exporter-1.6.0.linux-amd64.tar.gz -C /opt/
    echo "Installation completed"
}

install_alert_manager() {
    echo "Installing alert manager..."
    sudo wget https://github.com/prometheus/alertmanager/releases/download/v0.25.0/alertmanager-0.25.0.linux-amd64.tar.gz
    sudo tar -xzvf alertmanager-0.25.0.linux-amd64.tar.gz -C /opt/
    echo "Installation completed"
}

create_service_file() {
    echo "Creating systemd service file for ${SERVICE_NAME}..."
    sudo tee /etc/systemd/system/${SERVICE_NAME}.service >/dev/null <<EOF
[Unit]
Description=${SERVICE_DESCRIPTION}
After=network.target

[Service]
Type=simple
ExecStart=${EXEC_START}
WorkingDirectory=${WORKING_DIR}
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

    echo "Service file created at /etc/systemd/system/${SERVICE_NAME}.service."
}

reload_and_enable_service() {
    echo "Reloading systemd and enabling the service..."

    sudo systemctl daemon-reload
    sudo systemctl enable ${SERVICE_NAME}
    sudo systemctl start ${SERVICE_NAME}

    echo "${SERVICE_NAME} service is enabled and started."
}

while true; do
    # Display options
    echo "Please choose an option:"
    echo "1) Install Prometheus"
    echo "2) Install Node Exporter"
    echo "3) Install Alert Manager"
    echo "4) Exit"

    # Prompt to user
    read -p "Enter your choice: " choice

    case $choice in
    1)
        install_prometheus
        (
            echo "Initializing prometheus setup..."
            read -p "Want to continue? (y/n) : install_now"
            if [[ "$install_now" =~ ^[Yy]$ ]]; then
                SERVICE_NAME="prometheus"
                SERVICE_DESCRIPTION="PROMETHEUS"
                EXEC_START="/opt/prometheus-2.45.0.linux-amd64/prometheus --config.file=/opt/prometheus-2.45.0.linux-amd64/prometheus.yml --storage.tsdb.path=/opt/prometheus-2.45.0.linux-amd64/data"
                WORKING_DIR="/opt/prometheus-2.45.0.linux-amd64"
                create_service_file
                reload_and_enable_service
                echo "prometheus setup is completed."
            else
                echo "Setup canceled."
            fi
        )
        ;;
    2)
        install_node_exporter
        (
            echo "Initializing node exporter setup..."
            read -p "Want to continue? (y/n) : install_now"
            if [[ "$install_now" =~ ^[Yy]$ ]]; then
                SERVICE_NAME="node_exporter"
                SERVICE_DESCRIPTION="NODE EXPORTER"
                EXEC_START="/opt/node_exporter-1.6.0.linux-amd64/node_exporter"
                WORKING_DIR="/opt/node_exporter-1.6.0.linux-amd64"
                create_service_file
                reload_and_enable_service
                echo "Node exporter setup is completed"
            else
                echo "Setup canceled."
            fi
        )
        ;;
    3)
        install_alert_manager
        (
            echo "Initializing Alert manager setup..."
            read -p "Want to continue? (y/n) : install_now"
            if [[ "$install_now" =~ ^[Yy]$ ]]; then
                SERVICE_NAME="alert_manager"
                SERVICE_DESCRIPTION="ALERT MANAGER"
                EXEC_START="/opt/alertmanager-0.25.0.linux-amd64/alertmanager"
                WORKING_DIR="/opt/alertmanager-0.25.0.linux-amd64"
                create_service_file
                reload_and_enable_service
                echo "Alert manager setup is completed"
            else
                echo "Setup canceled."
            fi
        )
        ;;
    4)
        echo "Exiting..."
        break
        ;;
    *)
        echo "Invalid choice, try again."
        ;;
    esac
done
