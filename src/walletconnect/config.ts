/**
 * WalletConnect Configuration for Stacks Integration
 * https://docs.walletconnect.network/wallet-sdk/web/installation
 */

export const walletConnectConfig = {
  projectId: process.env.WALLETCONNECT_PROJECT_ID || '', // Get from https://cloud.walletconnect.com
  metadata: {
    name: 'Talent Ledger',
    description: 'Talent Ledger - Stacks DApp',
    url: 'https://talent-ledger.com', // Update with your actual URL
    icons: ['https://talent-ledger.com/icon.png'], // Update with your actual icon
  },
  // Deployed contract address
  contractAddress: 'SPHB047A30W99178TR7KE0784C2GV22070JTKX8.talent-ledger',
  // Stacks chain configuration
  chains: {
    stacks: {
      mainnet: {
        chainId: 'stacks:mainnet',
        name: 'Stacks Mainnet',
        rpc: 'https://stacks-node-api.mainnet.stacks.co',
      },
      testnet: {
        chainId: 'stacks:testnet',
        name: 'Stacks Testnet',
        rpc: 'https://stacks-node-api.testnet.stacks.co',
      },
      devnet: {
        chainId: 'stacks:devnet',
        name: 'Stacks Devnet',
        rpc: 'http://localhost:3999',
      },
    },
  },
};

export type StacksNetwork = 'mainnet' | 'testnet' | 'devnet';

export interface StacksAddress {
  symbol: string;
  address: string;
}

export interface WalletConnectSession {
  topic: string;
  addresses: StacksAddress[];
  network: StacksNetwork;
}
