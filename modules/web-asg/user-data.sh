#!/bin/bash
set -e

# Update system
dnf update -y

# Install Apache and required tools
dnf install -y httpd jq

# Get instance metadata
INSTANCE_ID=$(ec2-metadata --instance-id | cut -d " " -f 2)
AVAILABILITY_ZONE=$(ec2-metadata --availability-zone | cut -d " " -f 2)

# Create web application
cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EC2 Web Application</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            text-align: center;
            max-width: 600px;
        }
        h1 {
            color: #333;
            margin-bottom: 20px;
        }
        .instance-info {
            background: #f7f7f7;
            padding: 20px;
            border-radius: 5px;
            margin: 20px 0;
        }
        .instance-id {
            font-size: 24px;
            color: #667eea;
            font-weight: bold;
            margin: 10px 0;
        }
        .metadata {
            color: #666;
            font-size: 14px;
            margin-top: 10px;
        }
        .environment {
            display: inline-block;
            background: #667eea;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 12px;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Web Application Running on AWS</h1>
        <div class="instance-info">
            <p>You're currently running on:</p>
            <div class="instance-id">$INSTANCE_ID</div>
            <div class="metadata">
                <p><strong>Availability Zone:</strong> $AVAILABILITY_ZONE</p>
                <p><strong>Environment:</strong> <span class="environment">${environment}</span></p>
            </div>
        </div>
        <p style="color: #666; font-size: 14px;">
            This instance is part of an Auto Scaling Group behind an Application Load Balancer
        </p>
    </div>
</body>
</html>
EOF

# Create health check endpoint
cat > /var/www/html/health <<EOF
OK
EOF

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Configure Apache to log instance ID
echo "ServerTokens Prod" >> /etc/httpd/conf/httpd.conf
echo "ServerSignature Off" >> /etc/httpd/conf/httpd.conf

# Restart Apache to apply changes
systemctl restart httpd
