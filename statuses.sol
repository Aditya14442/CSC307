// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Status {
    // Maximum allowed length for a status
    uint256 public constant MAX_STATUS_LENGTH = 280;

    // Mapping to store user statuses
    mapping(address => string) private statuses;

    // Mapping to track if a user's status is private
    mapping(address => bool) private privateStatuses;

    // Event to log status updates (for public statuses)
    event StatusUpdated(address indexed user, string newStatus);

    // Event to log status deletions
    event StatusDeleted(address indexed user);

    // Function to set the status
    function setStatus(string memory newStatus) public {
        // Ensure the status length does not exceed the maximum allowed length
        require(
            bytes(newStatus).length <= MAX_STATUS_LENGTH,
            "Status exceeds maximum length"
        );

        statuses[msg.sender] = newStatus;
        privateStatuses[msg.sender] = false; // Default to public status when updated

        // Emit event only for public statuses
        if (!privateStatuses[msg.sender]) {
            emit StatusUpdated(msg.sender, newStatus);
        }
    }

    // Function to make the status private
    function setPrivateStatus(bool isPrivate) public {
        privateStatuses[msg.sender] = isPrivate;
    }

    // Function to get the status of a user
    function getStatus(address user) public view returns (string memory) {
        // If status is private, restrict access to the user or authorized party
        if (privateStatuses[user] && user != msg.sender) {
            revert("Status is private");
        }
        return statuses[user];
    }

    // Function to delete the user's status
    function deleteStatus() public {
        // Ensure that the sender has a status set
        require(bytes(statuses[msg.sender]).length > 0, "No status to delete");

        // Delete the status
        delete statuses[msg.sender];
        delete privateStatuses[msg.sender]; // Optionally remove private status flag as well

        // Emit status deletion event
        emit StatusDeleted(msg.sender);
    }

    // Function to check if the user's status is private
    function isPrivateStatus(address user) public view returns (bool) {
        return privateStatuses[user];
    }
}
