// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface INotification {
    event AddDelegate(address channel, address delegate);
    event ChannelAlias(
        string _chainName,
        uint256 indexed _chainID,
        address indexed _channelOwnerAddress,
        string _ethereumChannelAddress
    );
    event PublicKeyRegistered(address indexed owner, bytes publickey);
    event RemoveDelegate(address channel, address delegate);
    event SendNotification(
        address indexed channel,
        address indexed recipient,
        bytes identity
    );
    event Subscribe(address indexed channel, address indexed user);
    event Unsubscribe(address indexed channel, address indexed user);
    event UserNotifcationSettingsAdded(
        address _channel,
        address _user,
        uint256 _notifID,
        string _notifSettings
    );

    function DOMAIN_TYPEHASH() external view returns (bytes32);

    function EPNSCoreAddress() external view returns (address);

    function NAME_HASH() external view returns (bytes32);

    function SEND_NOTIFICATION_TYPEHASH() external view returns (bytes32);

    function SUBSCRIBE_TYPEHASH() external view returns (bytes32);

    function UNSUBSCRIBE_TYPEHASH() external view returns (bytes32);

    function addDelegate(address _delegate) external;

    function batchSubscribe(address[] memory _channelList)
        external
        returns (bool);

    function batchUnsubscribe(address[] memory _channelList)
        external
        returns (bool);

    function broadcastUserPublicKey(bytes memory _publicKey) external;

    function chainID() external view returns (uint256);

    function chainName() external view returns (string memory);

    function changeUserChannelSettings(
        address _channel,
        uint256 _notifID,
        string memory _notifSettings
    ) external;

    function completeMigration() external;

    function delegatedNotificationSenders(address, address)
        external
        view
        returns (bool);

    function getWalletFromPublicKey(bytes memory _publicKey)
        external
        pure
        returns (address wallet);

    function governance() external view returns (address);

    function initialize(address _pushChannelAdmin, string memory _chainName)
        external
        returns (bool);

    function isMigrationComplete() external view returns (bool);

    function isUserSubscribed(address _channel, address _user)
        external
        view
        returns (bool);

    function mapAddressUsers(uint256) external view returns (address);

    function migrateSubscribeData(
        uint256 _startIndex,
        uint256 _endIndex,
        address[] memory _channelList,
        address[] memory _usersList
    ) external returns (bool);

    function name() external view returns (string memory);

    function nonces(address) external view returns (uint256);

    function pushChannelAdmin() external view returns (address);

    function removeDelegate(address _delegate) external;

    function sendNotifBySig(
        address _channel,
        address _recipient,
        address _signer,
        bytes memory _identity,
        uint256 nonce,
        uint256 expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (bool);

    function sendNotification(
        address _channel,
        address _recipient,
        bytes memory _identity
    ) external returns (bool);

    function setEPNSCoreAddress(address _coreAddress) external;

    function setGovernanceAddress(address _governanceAddress) external;

    function subscribe(address _channel) external returns (bool);

    function subscribeBySig(
        address channel,
        address subscriber,
        uint256 nonce,
        uint256 expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function subscribeViaCore(address _channel, address _user)
        external
        returns (bool);

    function transferPushChannelAdminControl(address _newAdmin) external;

    function unSubscribeViaCore(address _channel, address _user)
        external
        returns (bool);

    function unsubscribe(address _channel) external returns (bool);

    function unsubscribeBySig(
        address channel,
        address subscriber,
        uint256 nonce,
        uint256 expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function userToChannelNotifs(address, address)
        external
        view
        returns (string memory);

    function users(address)
        external
        view
        returns (
            bool userActivated,
            bool publicKeyRegistered,
            uint256 userStartBlock,
            uint256 subscribedCount
        );

    function usersCount() external view returns (uint256);

    function verifyChannelAlias(string memory _channelAddress) external;
}