module.exports = {

    80001: {
        CHAIN_NAME: "MUMBAI",
        NETWORK_NAME: "polygon_testnet",
        EIP712_NAME : "CrossSyncGateway",
        EIP712_VERSION : "0",
        CHAIN_NATIVE_CURRENCY_WRAPPED_ADDRESS: "0x9c3c9283d3e44854697cd22d3faa240cfb032889",
        CHAIN_NATIVE_CURRENCY_ADDRESS: "0x0000000000000000000000000000000000001010",
        OWNER_ADDRESS: "0x8FAab0963aE8296Cd504559324c2572929B489a3",
        MESSENGERS: {
            CONNEXT: {
                SMART_CONTRACT_NAME: "ConnextImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/ConnextImpl.sol",
                GATEWAY_ADDRESS: "0x2334937846Ab2A3FCE747b32587e1A1A2f6EEC5a"
            },
            AXELAR: {
                SMART_CONTRACT_NAME: "AxelarImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/AxelarImpl.sol",
                GATEWAY_ADDRESS: "0xBF62ef1486468a6bd26Dd669C06db43dEd5B849B",
                GAS_PAYMASTER: "0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6"
            },
            CCIP: {
                SMART_CONTRACT_NAME: "ChainlinkCCIPImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/ChainlinkCCIPImpl.sol",
                ROUTER_ADDRESS: "0x70499c328e1E2a3c41108bd3730F6670a44595D1"
            },
            WORMHOLE: {
                SMART_CONTRACT_NAME: "WormholeImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/WormholeImpl.sol",
                RELAYER_ADDRESS: "0x0591C25ebd0580E0d4F27A82Fc2e24E7489CB5e0"
            },
            HYPERLANE: {
                SMART_CONTRACT_NAME: "HyperlaneImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/HyperlaneImpl.sol",
                MAILBOX_ADDRESS: "0xCC737a94FecaeC165AbCf12dED095BB13F037685",
                GAS_PAYMASTER: "0x8f9C3888bFC8a5B25AED115A82eCbb788b196d2a"
            },
        }

    },


    534351: {
        CHAIN_NAME: "SCROLL",
        NETWORK_NAME: "scroll_testnet",
        EIP712_NAME : "CrossSyncGateway",
        EIP712_VERSION : "0",
        CHAIN_NATIVE_CURRENCY_WRAPPED_ADDRESS: "0x0000000000000000000000000000000000001010",
        CHAIN_NATIVE_CURRENCY_ADDRESS: "0x0000000000000000000000000000000000001010",
        OWNER_ADDRESS: "0x8FAab0963aE8296Cd504559324c2572929B489a3",
        MESSENGERS: { 
            AXELAR: {
                SMART_CONTRACT_NAME: "AxelarImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/AxelarImpl.sol",
                GATEWAY_ADDRESS: "0xe432150cce91c13a887f7D836923d5597adD8E31",
                GAS_PAYMASTER: "0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6"
            }
        }

    },


    5001: {
        CHAIN_NAME: "MANTLE",
        NETWORK_NAME: "mantle_testnet",
        EIP712_NAME : "CrossSyncGateway",
        EIP712_VERSION : "0",
        CHAIN_NATIVE_CURRENCY_WRAPPED_ADDRESS: "0x0000000000000000000000000000000000001010",
        CHAIN_NATIVE_CURRENCY_ADDRESS: "0x0000000000000000000000000000000000001010",
        OWNER_ADDRESS: "0x8FAab0963aE8296Cd504559324c2572929B489a3",
        MESSENGERS: {
            HYPERLANE: {
                SMART_CONTRACT_NAME: "HyperlaneImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/HyperlaneImpl.sol",
                MAILBOX_ADDRESS: "0x0b07f32bbDba064269e2a2c947E314AE41c478ca",
                GAS_PAYMASTER: "0xc540171be1B4C034b268Aa670Bcd32ab5cfC713F"
            },
            AXELAR: {
                SMART_CONTRACT_NAME: "AxelarImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/AxelarImpl.sol",
                GATEWAY_ADDRESS: "0xe432150cce91c13a887f7D836923d5597adD8E31",
                GAS_PAYMASTER: "0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6"
            }
          
        }

    },


    1442: {
        CHAIN_NAME: "POLYGON_ZKEVM",
        NETWORK_NAME: "zkevm_testnet",
        EIP712_NAME : "CrossSyncGateway",
        EIP712_VERSION : "0",
        CHAIN_NATIVE_CURRENCY_WRAPPED_ADDRESS: "0x0000000000000000000000000000000000001010",
        CHAIN_NATIVE_CURRENCY_ADDRESS: "0x0000000000000000000000000000000000001010",
        OWNER_ADDRESS: "0x8FAab0963aE8296Cd504559324c2572929B489a3",
        MESSENGERS: {
            CONNEXT: {
                SMART_CONTRACT_NAME: "ConnextImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/ConnextImpl.sol",
                GATEWAY_ADDRESS: "0x20b4789065DE09c71848b9A4FcAABB2c10006FA2"
            },
            HYPERLANE: {
                SMART_CONTRACT_NAME: "HyperlaneImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/HyperlaneImpl.sol",
                MAILBOX_ADDRESS: "0x0282ee93886E62627C863D9Ec88F1408eA7Aeb3B",
                GAS_PAYMASTER: "0x57e69f9cC96Fb9324a196322367520ecE437d896"
            },
            AXELAR: {
                SMART_CONTRACT_NAME: "AxelarImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/AxelarImpl.sol",
                GATEWAY_ADDRESS: "0x999117D44220F33e0441fbAb2A5aDB8FF485c54D",
                GAS_PAYMASTER: "0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6"
            }
        }

    },
    

    5: {
        CHAIN_NAME: "GOERLI",
        NETWORK_NAME: "goerli",
        EIP712_NAME : "CrossSyncGateway",
        EIP712_VERSION : "0",
        CHAIN_NATIVE_CURRENCY_WRAPPED_ADDRESS: "0x0000000000000000000000000000000000001010",
        CHAIN_NATIVE_CURRENCY_ADDRESS: "0x0000000000000000000000000000000000001010",
        OWNER_ADDRESS: "0x8FAab0963aE8296Cd504559324c2572929B489a3",
        MESSENGERS: {
            CONNEXT: {
                SMART_CONTRACT_NAME: "ConnextImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/ConnextImpl.sol",
                GATEWAY_ADDRESS: "0xFCa08024A6D4bCc87275b1E4A1E22B71fAD7f649"
            },
            AXELAR: {
                SMART_CONTRACT_NAME: "AxelarImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/AxelarImpl.sol",
                GATEWAY_ADDRESS: "0xe432150cce91c13a887f7D836923d5597adD8E31",
                GAS_PAYMASTER: "0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6"
            },
            WORMHOLE: {
                SMART_CONTRACT_NAME: "WormholeImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/WormholeImpl.sol",
                RELAYER_ADDRESS: "0xAd753479354283eEE1b86c9470c84D42f229FF43"
            },
            HYPERLANE: {
                SMART_CONTRACT_NAME: "HyperlaneImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/HyperlaneImpl.sol",
                MAILBOX_ADDRESS: "0xCC737a94FecaeC165AbCf12dED095BB13F037685",
                GAS_PAYMASTER: "0x8f9C3888bFC8a5B25AED115A82eCbb788b196d2a"
            },
        }

    },

    11155111: {
        CHAIN_NAME: "SEPOLIA",
        NETWORK_NAME: "sepolia",
        EIP712_NAME : "CrossSyncGateway",
        EIP712_VERSION : "0",
        CHAIN_NATIVE_CURRENCY_WRAPPED_ADDRESS: "0x0000000000000000000000000000000000001010",
        CHAIN_NATIVE_CURRENCY_ADDRESS: "0x0000000000000000000000000000000000001010",
        OWNER_ADDRESS: "0x8FAab0963aE8296Cd504559324c2572929B489a3",
        MESSENGERS: {
            CCIP: {
                SMART_CONTRACT_NAME: "ChainlinkCCIPImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/ChainlinkCCIPImpl.sol",
                ROUTER_ADDRESS: "0xD0daae2231E9CB96b94C8512223533293C3693Bf"
            },
        }

    },
    
}