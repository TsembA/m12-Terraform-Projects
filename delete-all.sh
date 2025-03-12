#!/bin/bash

# Ensure AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it first."
    exit 1
fi

# Delete all EC2 instances
echo "Fetching all running EC2 instances..."
INSTANCE_IDS=$(aws ec2 describe-instances --query "Reservations[*].Instances[*].InstanceId" --output text)

if [[ -z "$INSTANCE_IDS" ]]; then
    echo "No EC2 instances found."
else
    echo "Terminating EC2 instances: $INSTANCE_IDS"
    aws ec2 terminate-instances --instance-ids $INSTANCE_IDS
    echo "Waiting for instances to terminate..."
    aws ec2 wait instance-terminated --instance-ids $INSTANCE_IDS
    echo "All EC2 instances terminated."
fi

# Get all VPCs
VPC_IDS=$(aws ec2 describe-vpcs --query "Vpcs[*].VpcId" --output text)

if [[ -z "$VPC_IDS" ]]; then
    echo "No VPCs found. Exiting..."
    exit 0
fi

for VPC_ID in $VPC_IDS; do
    echo "Deleting resources in VPC: $VPC_ID"

    # Detach and delete Internet Gateways
    IGW_IDS=$(aws ec2 describe-internet-gateways --query "InternetGateways[?Attachments[?VpcId=='$VPC_ID']].InternetGatewayId" --output text)
    for IGW_ID in $IGW_IDS; do
        echo " Detaching and deleting Internet Gateway: $IGW_ID"
        aws ec2 detach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID
        aws ec2 delete-internet-gateway --internet-gateway-id $IGW_ID
    done

    # Delete Subnets
    SUBNET_IDS=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" --query "Subnets[*].SubnetId" --output text)
    for SUBNET_ID in $SUBNET_IDS; do
        echo " Deleting Subnet: $SUBNET_ID"
        aws ec2 delete-subnet --subnet-id $SUBNET_ID
    done

    # Delete Route Tables (excluding the main one)
    RTB_IDS=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID" --query "RouteTables[?Associations[?Main==\`false\`]].RouteTableId" --output text)
    for RTB_ID in $RTB_IDS; do
        echo " Deleting Route Table: $RTB_ID"
        aws ec2 delete-route-table --route-table-id $RTB_ID
    done

    # Delete Security Groups (excluding the default one)
    SG_IDS=$(aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$VPC_ID" --query "SecurityGroups[?GroupName!='default'].GroupId" --output text)
    for SG_ID in $SG_IDS; do
        echo " Deleting Security Group: $SG_ID"
        aws ec2 delete-security-group --group-id $SG_ID
    done

    # Finally, delete the VPC
    echo " Deleting VPC: $VPC_ID"
    aws ec2 delete-vpc --vpc-id $VPC_ID
done

echo "All EC2 instances, VPCs, and associated resources have been deleted."
