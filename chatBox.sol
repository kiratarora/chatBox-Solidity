// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract BlockChatApp {
    address[] public chats; // store address of all the deployed chat contracts
    address public manager; // store the manager of the chatBox

    constructor() {
        manager = msg.sender; //assigning the mananger
    }

    function latestChat() public view returns (address) {
        return chats[chats.length - 1]; // return latest chat
    }

    function incomingChat(address newChat) public {
        //helps add chat to the chat array when chat is coming in from another contract
        bool flag = false;
        for (uint256 i = 0; i < chats.length; i = i + 1) {
            if (chats[i] == newChat) {
                flag = true;
            }
        }
        if (!flag) {
            chats.push(newChat); // return all chats
        }
        Chat(newChat).addWallet2(manager);
    }

    function createChat(address chatReceiverBox) public {
        require(msg.sender == manager);
        address newChat = address(new Chat(manager));
        BlockChatApp(chatReceiverBox).incomingChat(newChat);
        chats.push(newChat);
    }

    function chatList() public view returns (address[] memory) {
        return chats;
    }
}

contract Chat {
    address public wallet1;
    address public wallet2;

    chatMessage[] chatLog;

    struct chatMessage {
        address sender;
        string message;
    }

    constructor(address creator) {
        wallet1 = creator;
    }

    function addWallet2(address manager2) public {
        wallet2 = manager2;
    }

    function sendMessage(string memory message) public {
        require(msg.sender == wallet1 || msg.sender == wallet2);
        chatMessage storage mess = chatLog.push();
        mess.message = message;
        mess.sender = msg.sender;
    }

    function getMessages() public view returns (chatMessage[] memory) {
        return chatLog;
    }
}
