module.exports = {

    COMMON: {
        OWNER_ADDRESS: "0x8137147256EF84caea5322C4A9BE7209f0709dd7",
        FEE_ADDRESS: "0x8137147256EF84caea5322C4A9BE7209f0709dd7"
    },

    80001: {
        ALL_CHAIN_DEPLOY_SCRIPT_ALLOWED: true,
        CHAIN_NAME: "MUMBAI",
        NETWORK_NAME: "polygon_testnet",
        EIP712_NAME : "CrossSyncGateway",
        EIP712_VERSION : "0",
        CHAIN_NATIVE_CURRENCY_WRAPPED_ADDRESS: "0x9c3c9283d3e44854697cd22d3faa240cfb032889",
        CHAIN_NATIVE_CURRENCY_ADDRESS: "0x0000000000000000000000000000000000001010",
        MESSENGERS: {
            CONNEXT: {
                SMART_CONTRACT_NAME: "ConnextImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/ConnextImpl.sol",
                GATEWAY_ADDRESS: "0x2334937846Ab2A3FCE747b32587e1A1A2f6EEC5a",
                CONNEXT_DOMAIN_ID: 9991
            },
            AXELAR: {
                SMART_CONTRACT_NAME: "AxelarImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/AxelarImpl.sol",
                GATEWAY_ADDRESS: "0xBF62ef1486468a6bd26Dd669C06db43dEd5B849B",
                GAS_PAYMASTER: "0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6",
                AXELAR_CHAIN_NAME: "Polygon"
            },
            CCIP: {
                SMART_CONTRACT_NAME: "ChainlinkCCIPImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/ChainlinkCCIPImpl.sol",
                ROUTER_ADDRESS: "0x1035CabC275068e0F4b745A29CEDf38E13aF41b1",
                CCIP_CHAIN_SELECTOR: '12532609583862916517'
            },
            WORMHOLE: {
                SMART_CONTRACT_NAME: "WormholeImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/WormholeImpl.sol",
                RELAYER_ADDRESS: "0x0591C25ebd0580E0d4F27A82Fc2e24E7489CB5e0",
                WORMHOLE_CHAIN_ID: 5
            },
            HYPERLANE: {
                SMART_CONTRACT_NAME: "HyperlaneImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/HyperlaneImpl.sol",
                MAILBOX_ADDRESS: "0x2d1889fe5B092CD988972261434F7E5f26041115",
                HYPERLANE_DOMAIN_ID: 80001
            },
        }

    },


    534351: {
        ALL_CHAIN_DEPLOY_SCRIPT_ALLOWED: true,
        CHAIN_NAME: "SCROLL_SEPOLIA",
        NETWORK_NAME: "scroll_sepolia",
        EIP712_NAME : "CrossSyncGateway",
        EIP712_VERSION : "0",
        CHAIN_NATIVE_CURRENCY_WRAPPED_ADDRESS: "0x0000000000000000000000000000000000001010",
        CHAIN_NATIVE_CURRENCY_ADDRESS: "0x0000000000000000000000000000000000001010",
        MESSENGERS: { 
            AXELAR: {
                SMART_CONTRACT_NAME: "AxelarImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/AxelarImpl.sol",
                GATEWAY_ADDRESS: "0xe432150cce91c13a887f7D836923d5597adD8E31",
                GAS_PAYMASTER: "0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6",
                AXELAR_CHAIN_NAME: "scroll"
            },
            HYPERLANE: {
                SMART_CONTRACT_NAME: "HyperlaneImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/HyperlaneImpl.sol",
                MAILBOX_ADDRESS: "0x3C5154a193D6e2955650f9305c8d80c18C814A68",
                HYPERLANE_DOMAIN_ID: 534351
            },
        }

    },


    5001: {
        ALL_CHAIN_DEPLOY_SCRIPT_ALLOWED: true,
        CHAIN_NAME: "MANTLE_TESTNET",
        NETWORK_NAME: "mantle_testnet",
        EIP712_NAME : "CrossSyncGateway",
        EIP712_VERSION : "0",
        CHAIN_NATIVE_CURRENCY_WRAPPED_ADDRESS: "0x0000000000000000000000000000000000001010",
        CHAIN_NATIVE_CURRENCY_ADDRESS: "0x0000000000000000000000000000000000001010",
        MESSENGERS: {
            AXELAR: {
                SMART_CONTRACT_NAME: "AxelarImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/AxelarImpl.sol",
                GATEWAY_ADDRESS: "0xe432150cce91c13a887f7D836923d5597adD8E31",
                GAS_PAYMASTER: "0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6",
                AXELAR_CHAIN_NAME: "mantle"
            }
          
        }

    },


    1442: {
        ALL_CHAIN_DEPLOY_SCRIPT_ALLOWED: true,
        CHAIN_NAME: "POLYGON_ZKEVM",
        NETWORK_NAME: "zkevm_testnet",
        EIP712_NAME : "CrossSyncGateway",
        EIP712_VERSION : "0",
        CHAIN_NATIVE_CURRENCY_WRAPPED_ADDRESS: "0x0000000000000000000000000000000000001010",
        CHAIN_NATIVE_CURRENCY_ADDRESS: "0x0000000000000000000000000000000000001010",
        MESSENGERS: {
            CONNEXT: {
                SMART_CONTRACT_NAME: "ConnextImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/ConnextImpl.sol",
                GATEWAY_ADDRESS: "0x20b4789065DE09c71848b9A4FcAABB2c10006FA2",
                CONNEXT_DOMAIN_ID: 1887071092
            },
            HYPERLANE: {
                SMART_CONTRACT_NAME: "HyperlaneImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/HyperlaneImpl.sol",
                MAILBOX_ADDRESS: "0x598facE78a4302f11E3de0bee1894Da0b2Cb71F8",
                HYPERLANE_DOMAIN_ID: 1442
            },
            AXELAR: {
                SMART_CONTRACT_NAME: "AxelarImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/AxelarImpl.sol",
                GATEWAY_ADDRESS: "0x999117D44220F33e0441fbAb2A5aDB8FF485c54D",
                GAS_PAYMASTER: "0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6",
                AXELAR_CHAIN_NAME: "polygon-zkevm"
            }
        }

    },
    

    5: {
        ALL_CHAIN_DEPLOY_SCRIPT_ALLOWED: true,
        CHAIN_NAME: "GOERLI",
        NETWORK_NAME: "goerli",
        EIP712_NAME : "CrossSyncGateway",
        EIP712_VERSION : "0",
        CHAIN_NATIVE_CURRENCY_WRAPPED_ADDRESS: "0x0000000000000000000000000000000000001010",
        CHAIN_NATIVE_CURRENCY_ADDRESS: "0x0000000000000000000000000000000000001010",
        MESSENGERS: {
            CONNEXT: {
                SMART_CONTRACT_NAME: "ConnextImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/ConnextImpl.sol",
                GATEWAY_ADDRESS: "0xFCa08024A6D4bCc87275b1E4A1E22B71fAD7f649",
                CONNEXT_DOMAIN_ID: 1735353714
            },
            AXELAR: {
                SMART_CONTRACT_NAME: "AxelarImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/AxelarImpl.sol",
                GATEWAY_ADDRESS: "0xe432150cce91c13a887f7D836923d5597adD8E31",
                GAS_PAYMASTER: "0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6",
                AXELAR_CHAIN_NAME: "ethereum-2"
            },
            WORMHOLE: {
                SMART_CONTRACT_NAME: "WormholeImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/WormholeImpl.sol",
                RELAYER_ADDRESS: "0x28D8F1Be96f97C1387e94A53e00eCcFb4E75175a",
                WORMHOLE_CHAIN_ID: 2
            },
            HYPERLANE: {
                SMART_CONTRACT_NAME: "HyperlaneImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/HyperlaneImpl.sol",
                MAILBOX_ADDRESS: "0x49cfd6Ef774AcAb14814D699e3F7eE36Fdfba932",
                HYPERLANE_DOMAIN_ID: 5
            },
        }

    },

    97: {
        ALL_CHAIN_DEPLOY_SCRIPT_ALLOWED: true,
        CHAIN_NAME: "BINANACE_TESTNET",
        NETWORK_NAME: "binance_testnet",
        EIP712_NAME : "CrossSyncGateway",
        EIP712_VERSION : "0",
        CHAIN_NATIVE_CURRENCY_WRAPPED_ADDRESS: "0x0000000000000000000000000000000000001010",
        CHAIN_NATIVE_CURRENCY_ADDRESS: "0x0000000000000000000000000000000000001010",
        MESSENGERS: {
            AXELAR: {
                SMART_CONTRACT_NAME: "AxelarImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/AxelarImpl.sol",
                GATEWAY_ADDRESS: "0x4D147dCb984e6affEEC47e44293DA442580A3Ec0",
                GAS_PAYMASTER: "0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6",
                AXELAR_CHAIN_NAME: "binance"
            },
            WORMHOLE: {
                SMART_CONTRACT_NAME: "WormholeImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/WormholeImpl.sol",
                RELAYER_ADDRESS: "0x80aC94316391752A193C1c47E27D382b507c93F3",
                WORMHOLE_CHAIN_ID: 4
            },
            HYPERLANE: {
                SMART_CONTRACT_NAME: "HyperlaneImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/HyperlaneImpl.sol",
                MAILBOX_ADDRESS: "0xF9F6F5646F478d5ab4e20B0F910C92F1CCC9Cc6D",
                HYPERLANE_DOMAIN_ID: 97
            },
            CCIP: {
                SMART_CONTRACT_NAME: "ChainlinkCCIPImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/ChainlinkCCIPImpl.sol",
                ROUTER_ADDRESS: "0xE1053aE1857476f36A3C62580FF9b016E8EE8F6f",
                CCIP_CHAIN_SELECTOR: '13264668187771770619'
            },
        }

    },

    43113: {
        ALL_CHAIN_DEPLOY_SCRIPT_ALLOWED: true,
        CHAIN_NAME: "AVALANCHE_TESTNET",
        NETWORK_NAME: "avalanche_testnet",
        EIP712_NAME : "CrossSyncGateway",
        EIP712_VERSION : "0",
        CHAIN_NATIVE_CURRENCY_WRAPPED_ADDRESS: "0x0000000000000000000000000000000000001010",
        CHAIN_NATIVE_CURRENCY_ADDRESS: "0x0000000000000000000000000000000000001010",
        MESSENGERS: {
            AXELAR: {
                SMART_CONTRACT_NAME: "AxelarImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/AxelarImpl.sol",
                GATEWAY_ADDRESS: "0xC249632c2D40b9001FE907806902f63038B737Ab",
                GAS_PAYMASTER: "0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6",
                AXELAR_CHAIN_NAME: "Avalanche"
            },
            WORMHOLE: {
                SMART_CONTRACT_NAME: "WormholeImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/WormholeImpl.sol",
                RELAYER_ADDRESS: "0xA3cF45939bD6260bcFe3D66bc73d60f19e49a8BB",
                WORMHOLE_CHAIN_ID: 6
            },
            HYPERLANE: {
                SMART_CONTRACT_NAME: "HyperlaneImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/HyperlaneImpl.sol",
                MAILBOX_ADDRESS: "0x5b6CFf85442B851A8e6eaBd2A4E4507B5135B3B0",
                HYPERLANE_DOMAIN_ID: 43113
            },
            CCIP: {
                SMART_CONTRACT_NAME: "ChainlinkCCIPImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/ChainlinkCCIPImpl.sol",
                ROUTER_ADDRESS: "0xF694E193200268f9a4868e4Aa017A0118C9a8177",
                CCIP_CHAIN_SELECTOR: '14767482510784806043'
            },

            TELEPORTER: {
                SMART_CONTRACT_NAME: "TeleporterImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/TeleporterImpl.sol",
                TELEPORTER_BLOCKCHAIN_ID: "0x7fc93d85c6d62c5b2ac0b519c87010ea5294012d1e407030d6acd0021cac10d5",
                TELEPORTER_ADDRESS: "0x253b2784c75e510dD0fF1da844684a1aC0aa5fcf",
            }
        }

    },

    779672: {
        ALL_CHAIN_DEPLOY_SCRIPT_ALLOWED: true,
        CHAIN_NAME: "DISPATCH_SUBNET",
        NETWORK_NAME: "dispatch_subnet",
        EIP712_NAME : "CrossSyncGateway",
        EIP712_VERSION : "0",
        CHAIN_NATIVE_CURRENCY_WRAPPED_ADDRESS: "0x0000000000000000000000000000000000001010",
        CHAIN_NATIVE_CURRENCY_ADDRESS: "0x0000000000000000000000000000000000001010",
        MESSENGERS: {
            TELEPORTER: {
                SMART_CONTRACT_NAME: "TeleporterImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/TeleporterImpl.sol",
                TELEPORTER_BLOCKCHAIN_ID: "0x9f3be606497285d0ffbb5ac9ba24aa60346a9b1812479ed66cb329f394a4b1c7",
                TELEPORTER_ADDRESS: "0x253b2784c75e510dD0fF1da844684a1aC0aa5fcf",
            }
        }

    },

    421613: {
        ALL_CHAIN_DEPLOY_SCRIPT_ALLOWED: true,
        CHAIN_NAME: "ARBITRUM_GOERLI",
        NETWORK_NAME: "arbitrum_goerli",
        EIP712_NAME : "CrossSyncGateway",
        EIP712_VERSION : "0",
        CHAIN_NATIVE_CURRENCY_WRAPPED_ADDRESS: "0x0000000000000000000000000000000000001010",
        CHAIN_NATIVE_CURRENCY_ADDRESS: "0x0000000000000000000000000000000000001010",
        MESSENGERS: {
            CONNEXT: {
                SMART_CONTRACT_NAME: "ConnextImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/ConnextImpl.sol",
                GATEWAY_ADDRESS: "0x2075c9E31f973bb53CAE5BAC36a8eeB4B082ADC2",
                CONNEXT_DOMAIN_ID: 1734439522
            },
            AXELAR: {
                SMART_CONTRACT_NAME: "AxelarImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/AxelarImpl.sol",
                GATEWAY_ADDRESS: "0xe432150cce91c13a887f7D836923d5597adD8E31",
                GAS_PAYMASTER: "0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6",
                AXELAR_CHAIN_NAME: "arbitrum"
            },
            WORMHOLE: {
                SMART_CONTRACT_NAME: "WormholeImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/WormholeImpl.sol",
                RELAYER_ADDRESS: "0xAd753479354283eEE1b86c9470c84D42f229FF43",
                WORMHOLE_CHAIN_ID: 23
            },
            HYPERLANE: {
                SMART_CONTRACT_NAME: "HyperlaneImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/HyperlaneImpl.sol",
                MAILBOX_ADDRESS: "0x13dABc0351407d5aAa0A50003a166A73b4febfDc",
                HYPERLANE_DOMAIN_ID: 421613
            }
        }

    },

    421614: {
        ALL_CHAIN_DEPLOY_SCRIPT_ALLOWED: true,
        CHAIN_NAME: "ARBITRUM_SEPOLIA",
        NETWORK_NAME: "arbitrum_sepolia",
        EIP712_NAME : "CrossSyncGateway",
        EIP712_VERSION : "0",
        CHAIN_NATIVE_CURRENCY_WRAPPED_ADDRESS: "0x0000000000000000000000000000000000001010",
        CHAIN_NATIVE_CURRENCY_ADDRESS: "0x0000000000000000000000000000000000001010",
        MESSENGERS: {
            CCIP: {
                SMART_CONTRACT_NAME: "ChainlinkCCIPImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/ChainlinkCCIPImpl.sol",
                ROUTER_ADDRESS: "0x2a9C5afB0d0e4BAb2BCdaE109EC4b0c4Be15a165",
                CCIP_CHAIN_SELECTOR: '3478487238524512106'
            },
        }

    },


    420: {
        ALL_CHAIN_DEPLOY_SCRIPT_ALLOWED: true,
        CHAIN_NAME: "OPTIMISM_GOERLI",
        NETWORK_NAME: "optimism_goerli",
        EIP712_NAME : "CrossSyncGateway",
        EIP712_VERSION : "0",
        CHAIN_NATIVE_CURRENCY_WRAPPED_ADDRESS: "0x0000000000000000000000000000000000001010",
        CHAIN_NATIVE_CURRENCY_ADDRESS: "0x0000000000000000000000000000000000001010",
        MESSENGERS: {
            CONNEXT: {
                SMART_CONTRACT_NAME: "ConnextImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/ConnextImpl.sol",
                GATEWAY_ADDRESS: "0x5Ea1bb242326044699C3d81341c5f535d5Af1504",
                CONNEXT_DOMAIN_ID: 1735356532
            },
            AXELAR: {
                SMART_CONTRACT_NAME: "AxelarImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/AxelarImpl.sol",
                GATEWAY_ADDRESS: "0xe432150cce91c13a887f7D836923d5597adD8E31",
                GAS_PAYMASTER: "0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6",
                AXELAR_CHAIN_NAME: "optimism"
            },
            WORMHOLE: {
                SMART_CONTRACT_NAME: "WormholeImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/WormholeImpl.sol",
                RELAYER_ADDRESS: "0x01A957A525a5b7A72808bA9D10c389674E459891",
                WORMHOLE_CHAIN_ID: 24
            },
            HYPERLANE: {
                SMART_CONTRACT_NAME: "HyperlaneImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/HyperlaneImpl.sol",
                MAILBOX_ADDRESS: "0xB5f021728Ea6223E3948Db2da61d612307945eA2",
                HYPERLANE_DOMAIN_ID: 420
            },
            CCIP: {
                SMART_CONTRACT_NAME: "ChainlinkCCIPImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/ChainlinkCCIPImpl.sol",
                ROUTER_ADDRESS: "0xcc5a0B910D9E9504A7561934bed294c51285a78D",
                CCIP_CHAIN_SELECTOR: '2664363617261496610'
            },
        }

    },

    84531: {
        ALL_CHAIN_DEPLOY_SCRIPT_ALLOWED: true,
        CHAIN_NAME: "BASE_GOERLI",
        NETWORK_NAME: "base_goerli",
        EIP712_NAME : "CrossSyncGateway",
        EIP712_VERSION : "0",
        CHAIN_NATIVE_CURRENCY_WRAPPED_ADDRESS: "0x0000000000000000000000000000000000001010",
        CHAIN_NATIVE_CURRENCY_ADDRESS: "0x0000000000000000000000000000000000001010",
        MESSENGERS: {
            AXELAR: {
                SMART_CONTRACT_NAME: "AxelarImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/AxelarImpl.sol",
                GATEWAY_ADDRESS: "0xe432150cce91c13a887f7D836923d5597adD8E31",
                GAS_PAYMASTER: "0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6",
                AXELAR_CHAIN_NAME: "base"
            },
            WORMHOLE: {
                SMART_CONTRACT_NAME: "WormholeImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/WormholeImpl.sol",
                RELAYER_ADDRESS: "0xea8029CD7FCAEFFcD1F53686430Db0Fc8ed384E1",
                WORMHOLE_CHAIN_ID: 30
            },
            HYPERLANE: {
                SMART_CONTRACT_NAME: "HyperlaneImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/HyperlaneImpl.sol",
                MAILBOX_ADDRESS: "0x58483b754Abb1E8947BE63d6b95DF75b8249543A",
                HYPERLANE_DOMAIN_ID: 84531
            },
            CCIP: {
                SMART_CONTRACT_NAME: "ChainlinkCCIPImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/ChainlinkCCIPImpl.sol",
                ROUTER_ADDRESS: "0x80AF2F44ed0469018922c9F483dc5A909862fdc2",
                CCIP_CHAIN_SELECTOR: '5790810961207155433'
            },
        }

    },

    314159: {
        ALL_CHAIN_DEPLOY_SCRIPT_ALLOWED: true,
        CHAIN_NAME: "FILECOIN",
        NETWORK_NAME: "filecoin_testnet",
        EIP712_NAME : "CrossSyncGateway",
        EIP712_VERSION : "0",
        CHAIN_NATIVE_CURRENCY_WRAPPED_ADDRESS: "0x0000000000000000000000000000000000001010",
        CHAIN_NATIVE_CURRENCY_ADDRESS: "0x0000000000000000000000000000000000001010",
        MESSENGERS: {
            AXELAR: {
                SMART_CONTRACT_NAME: "AxelarImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/AxelarImpl.sol",
                GATEWAY_ADDRESS: "0x999117D44220F33e0441fbAb2A5aDB8FF485c54D",
                GAS_PAYMASTER: "0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6",
                AXELAR_CHAIN_NAME: "filecoin-2"
            }
        }

    },

    59140: {
        ALL_CHAIN_DEPLOY_SCRIPT_ALLOWED: true,
        CHAIN_NAME: "LINEA_GOERLI",
        NETWORK_NAME: "linea_goerli",
        EIP712_NAME : "CrossSyncGateway",
        EIP712_VERSION : "0",
        CHAIN_NATIVE_CURRENCY_WRAPPED_ADDRESS: "0x0000000000000000000000000000000000001010",
        CHAIN_NATIVE_CURRENCY_ADDRESS: "0x0000000000000000000000000000000000001010",
        MESSENGERS: {
            CONNEXT: {
                SMART_CONTRACT_NAME: "ConnextImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/ConnextImpl.sol",
                GATEWAY_ADDRESS: "0xfdb6B853C1945Dbffe78A3091BeBB9A928234fA3",
                CONNEXT_DOMAIN_ID: 1668247156
            },
            AXELAR: {
                SMART_CONTRACT_NAME: "AxelarImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/AxelarImpl.sol",
                GATEWAY_ADDRESS: "0xe432150cce91c13a887f7D836923d5597adD8E31",
                GAS_PAYMASTER: "0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6",
                AXELAR_CHAIN_NAME: "linea"
            }
        }

    },

    11155111: {
        ALL_CHAIN_DEPLOY_SCRIPT_ALLOWED: true,
        CHAIN_NAME: "SEPOLIA",
        NETWORK_NAME: "sepolia",
        EIP712_NAME : "CrossSyncGateway",
        EIP712_VERSION : "0",
        CHAIN_NATIVE_CURRENCY_WRAPPED_ADDRESS: "0x0000000000000000000000000000000000001010",
        CHAIN_NATIVE_CURRENCY_ADDRESS: "0x0000000000000000000000000000000000001010",
        MESSENGERS: {
            CCIP: {
                SMART_CONTRACT_NAME: "ChainlinkCCIPImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/ChainlinkCCIPImpl.sol",
                ROUTER_ADDRESS: "0x0BF3dE8c5D3e8A2B34D2BEeB17ABfCeBaf363A59",
                CCIP_CHAIN_SELECTOR: '16015286601757825753'
            },
            HYPERLANE: {
                SMART_CONTRACT_NAME: "HyperlaneImpl",
                SMART_CONTRACT_PATH: "contracts/MessagingImpls/HyperlaneImpl.sol",
                MAILBOX_ADDRESS: "0xfFAEF09B3cd11D9b20d1a19bECca54EEC2884766",
                HYPERLANE_DOMAIN_ID: 11155111
            },
        }

    },
    
}