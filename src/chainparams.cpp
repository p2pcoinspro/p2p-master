// Copyright (c) 2010 Satoshi Nakamoto
// Copyright (c) 2009-2014 The Bitcoin developers
// Copyright (c) 2014-2015 The Dash developers
// Copyright (c) 2015-2017 The PIVX developers
// Copyright (c) 2017-2018 The Bitcoin Green developers
// Copyright (c) 2018 The p2p developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#include "chainparams.h"
#include "random.h"
#include "util.h"
#include "utilstrencodings.h"

#include <assert.h>

#include <boost/assign/list_of.hpp>

using namespace std;
using namespace boost::assign;

struct SeedSpec6 {
    uint8_t addr[16];
    uint16_t port;
};

#include "chainparamsseeds.h"

/**
 * Main network
 */

//! Convert the pnSeeds6 array into usable address objects.
static void convertSeed6(std::vector<CAddress>& vSeedsOut, const SeedSpec6* data, unsigned int count)
{
    // It'll only connect to one or two seed nodes because once it connects,
    // it'll get a pile of addresses with newer timestamps.
    // Seed nodes are given a random 'last seen time' of between one and two
    // weeks ago.
    const int64_t nOneWeek = 7 * 24 * 60 * 60;
    for (unsigned int i = 0; i < count; i++) {
        struct in6_addr ip;
        memcpy(&ip, data[i].addr, sizeof(ip));
        CAddress addr(CService(ip, data[i].port));
        addr.nTime = GetTime() - GetRand(nOneWeek) - nOneWeek;
        vSeedsOut.push_back(addr);
    }
}

//   What makes a good checkpoint block?
// + Is surrounded by blocks with reasonable timestamps
//   (no blocks before with a timestamp after, none after with
//    timestamp before)
// + Contains no strange transactions
//static Checkpoints::MapCheckpoints mapCheckpoints =
//    boost::assign::map_list_of (0, uint256("0x00000291d02cc6230a9357a6552de601c5d48a76cd49e8a65bd81ed309091983"));

static Checkpoints::MapCheckpoints mapCheckpoints =
    boost::assign::map_list_of
    (0, uint256("0x00000b684592eca69dd056de0b68509587bbef1f5b5189144b1ad408f4af2fe8"))
    (12488, uint256("0x41feeeefb37b2fd376db33e1348252721bbd937df41acd893f49fd1f769d85ba"))
	 (55573, uint256("0x0b48d6b10654251f4460d65d60ddd5cf92339dda2e6350518912a3ebaa958643"));

static const Checkpoints::CCheckpointData data = {
    &mapCheckpoints,
    1546893371, // * UNIX timestamp of last checkpoint block
    111062,          // * total number of transactions between genesis and last checkpoint
                //   (the tx=... number in the SetBestChain debug.log lines)
    2000        // * estimated number of transactions per day after checkpoint
};

//static Checkpoints::MapCheckpoints mapCheckpointsTestnet =
//    boost::assign::map_list_of(0, uint256("0x000009b721acce547310644d6898369d98dcfc869866ed6a8dd76aab976df944"));
static Checkpoints::MapCheckpoints mapCheckpointsTestnet =
    boost::assign::map_list_of(0, uint256("0x000006b786ee9e022948360467e4d6375c7600464f237008dc854a48967eb901"));

static const Checkpoints::CCheckpointData dataTestnet = {
    &mapCheckpointsTestnet,
    1538246464,
    0,
    250};

//static Checkpoints::MapCheckpoints mapCheckpointsRegtest =
//    boost::assign::map_list_of(0, uint256("0x000006e76067d7354f7a21bfe0e30d51b1ba2cf87790d793ae15d91d3452c65e"));
static Checkpoints::MapCheckpoints mapCheckpointsRegtest =
    boost::assign::map_list_of(0, uint256("0x000008b785a990bc4a23c46a01cf227744229ee8d989e4834f95b3072d2235f7"));	

static const Checkpoints::CCheckpointData dataRegtest = {
    &mapCheckpointsRegtest,
    1537509605,
    0,
    100};

class CMainParams : public CChainParams
{
public:
    CMainParams()
    {
        networkID = CBaseChainParams::MAIN;
        strNetworkID = "main";
        /**
         * The message start string is designed to be unlikely to occur in normal data.
         * The characters are rarely used upper ASCII, not valid as UTF-8, and produce
         * a large 4-byte int at any alignment.
         */
        pchMessageStart[0] = 0xb2;
        pchMessageStart[1] = 0x3a;
        pchMessageStart[2] = 0x4f;
        pchMessageStart[3] = 0xbb;
        vAlertPubKey = ParseHex("04dfb61863d9d6e16fe77b475b5dd223b3cb15535d26bacfa6b6bf9a0cce6b3f7bf7986ae7e4564e936cb7b5251c1fcdbfd43b1325df9020ab41298134479a12df");
        nDefaultPort = 24513;
        bnProofOfWorkLimit = ~uint256(0) >> 16;
        nSubsidyHalvingInterval = 1050000;
        nMaxReorganizationDepth = 100;
        nEnforceBlockUpgradeMajority = 750;
        nRejectBlockOutdatedMajority = 950;
        nToCheckBlockUpgradeMajority = 1000;
        nMinerThreads = 1;
        nTargetTimespan = 1 * 60; // p2p: 1 day
        nTargetSpacing = 1 * 60;  // p2p: 1 minutes
        nMaturity = 21;
        nMasternodeCountDrift = 20;
        nMaxMoneyOut = 21000000 * COIN;

        /** Height or Time Based Activations **/
        nLastPOWBlock = 200;
        nModifierUpdateBlock = 1; // we use the version 2 for P2P

        /**
	python genesis.py -a quark-hash -z "FBI reaches out to 2nd woman who has accused Kavanaugh of sexual misconduct" -t 1543178982 -p 047d747338e3e06858b077e8c56507d5ef1d6da2eb30966d861ee7efe218a350c4f54872ead5723b4529fb0cb11f51d7ff3289c9ad431d683f425bf15976692ec9 -v 0
	04ffff001d01044b4642492072656163686573206f757420746f20326e6420776f6d616e2077686f206861732061636375736564204b6176616e61756768206f662073657875616c206d6973636f6e64756374
algorithm: quark-hash
merkle hash: e90e5ecc79da4653ef65a89257e26c5732cbd5aa2996399b87eb141b63ecabc4
pszTimestamp: FBI reaches out to 2nd woman who has accused Kavanaugh of sexual misconduct
pubkey: 047d747338e3e06858b077e8c56507d5ef1d6da2eb30966d861ee7efe218a350c4f54872ead5723b4529fb0cb11f51d7ff3289c9ad431d683f425bf15976692ec9
time: 1543178982
bits: 0x1e0ffff0
Searching for genesis hash..
22398.0 hash/s, estimate: 53.3 hgenesis hash found!
nonce: 26351457
genesis_hash: 00000735239480d9fad9154a1933fe49f84cb960cf228d17a94ac1e2f86f828c

         */
        const char* pszTimestamp = "FBI reaches out to 2nd woman who has accused Kavanaugh of sexual misconduct";
        CMutableTransaction txNew;
        txNew.vin.resize(1);
        txNew.vout.resize(1);
        txNew.vin[0].scriptSig = CScript() << 486604799 << CScriptNum(4) << vector<unsigned char>((const unsigned char*)pszTimestamp, (const unsigned char*)pszTimestamp + strlen(pszTimestamp));
        txNew.vout[0].nValue = 0 * COIN;
        txNew.vout[0].scriptPubKey = CScript() << ParseHex("047d747338e3e06858b077e8c56507d5ef1d6da2eb30966d861ee7efe218a350c4f54872ead5723b4529fb0cb11f51d7ff3289c9ad431d683f425bf15976692ec9") << OP_CHECKSIG;
        genesis.vtx.push_back(txNew);
        genesis.hashPrevBlock = 0;
        genesis.hashMerkleRoot = genesis.BuildMerkleTree();
        genesis.nVersion = 1;
        genesis.nTime = 1543178982;
        genesis.nBits = 0x1e0ffff0;
        genesis.nNonce = 26351457;

        hashGenesisBlock = genesis.GetHash();
        assert(hashGenesisBlock == uint256("0x00000735239480d9fad9154a1933fe49f84cb960cf228d17a94ac1e2f86f828c"));
        assert(genesis.hashMerkleRoot == uint256("0xe90e5ecc79da4653ef65a89257e26c5732cbd5aa2996399b87eb141b63ecabc4"));

        // DNS Seeding
	vSeeds.push_back(CDNSSeedData("seed.p2pcoin.network", "seed.p2pcoin.network"));
		  vSeeds.push_back(CDNSSeedData("46.101.112.164", "46.101.112.164"));
		  vSeeds.push_back(CDNSSeedData("46.101.239.165", "46.101.239.165"));
		  vSeeds.push_back(CDNSSeedData("46.101.252.79", "46.101.252.79"));
		  vSeeds.push_back(CDNSSeedData("188.166.166.224", "188.166.166.224"));
		  vSeeds.push_back(CDNSSeedData("46.101.240.63", "46.101.240.63"));
		  vSeeds.push_back(CDNSSeedData("46.101.155.60", "46.101.155.60"));
		  vSeeds.push_back(CDNSSeedData("46.101.237.194", "46.101.237.194"));
		  vSeeds.push_back(CDNSSeedData("46.101.206.227", "46.101.206.227"));
		  vSeeds.push_back(CDNSSeedData("46.101.181.5", "46.101.181.5"));
		  vSeeds.push_back(CDNSSeedData("46.101.204.56", "46.101.204.56"));
        vSeeds.push_back(CDNSSeedData("46.101.191.120", "46.101.191.120"));
        vSeeds.push_back(CDNSSeedData("159.89.23.26", "159.89.23.26"));
        vSeeds.push_back(CDNSSeedData("159.89.23.27", "159.89.23.27"));
        vSeeds.push_back(CDNSSeedData("159.65.127.168", "159.65.127.168"));
        vSeeds.push_back(CDNSSeedData("159.89.30.79", "159.89.30.79"));
        vSeeds.push_back(CDNSSeedData("46.101.101.246", "46.101.101.246"));
        vSeeds.push_back(CDNSSeedData("188.166.165.97", "188.166.165.97"));
        vSeeds.push_back(CDNSSeedData("69.55.62.57", "69.55.62.57"));
        vSeeds.push_back(CDNSSeedData("69.55.62.58", "69.55.62.58"));


        // p2p addresses start with 'p'
        base58Prefixes[PUBKEY_ADDRESS] = std::vector<unsigned char>(1, 55);
        // p2p script addresses start with 'p'
        base58Prefixes[SCRIPT_ADDRESS] = std::vector<unsigned char>(1, 55 );
        // p2p private keys start with 'p'  (?)
        base58Prefixes[SECRET_KEY] = std::vector<unsigned char>(1, 55);
        // p2p BIP32 pubkeys start with 'xpub' (Bitcoin defaults)
        base58Prefixes[EXT_PUBLIC_KEY] = boost::assign::list_of(0x04)(0x88)(0xB2)(0x1E).convert_to_container<std::vector<unsigned char> >();
        // p2p BIP32 prvkeys start with 'xprv' (Bitcoin defaults)
        base58Prefixes[EXT_SECRET_KEY] = boost::assign::list_of(0x04)(0x88)(0xAD)(0xE4).convert_to_container<std::vector<unsigned char> >();
        // BIP44 coin type is from https://github.com/satoshilabs/slips/blob/master/slip-0044.md
        base58Prefixes[EXT_COIN_TYPE] = boost::assign::list_of(0x80)(0x00)(0x00)(0x77).convert_to_container<std::vector<unsigned char> >();

        convertSeed6(vFixedSeeds, pnSeed6_main, ARRAYLEN(pnSeed6_main));

        fMiningRequiresPeers = true;
        fAllowMinDifficultyBlocks = false;
        fDefaultConsistencyChecks = false;
        fRequireStandard = true;
        fMineBlocksOnDemand = false;
        fSkipProofOfWorkCheck = false;
        fTestnetToBeDeprecatedFieldRPC = false;
        fHeadersFirstSyncingActive = false;

        nPoolMaxTransactions = 3;
        strSporkKey = "046a5e5b5065088ddc18dff9bb8bdfc1888c39b766198af468b9fadd104cc021744bba2863195575fa03c3499f90eea20f83d50a35be7afb6f0c6ba1138de4b640";
        strMasternodePoolDummyAddress = "VWRSmn8QshzHJcKEbnoDf65DwgD3xStMtJ";
        nStartMasternodePayments = genesis.nTime + 14400; // 3 hours after genesis creation

        nBudget_Fee_Confirmations = 6; // Number of confirmations for the finalization fee
    }

    const Checkpoints::CCheckpointData& Checkpoints() const
    {
        return data;
    }
};
static CMainParams mainParams;

/**
 * Testnet (v3)
 */
class CTestNetParams : public CMainParams
{
public:
    CTestNetParams()
    {
        networkID = CBaseChainParams::TESTNET;
        strNetworkID = "test";
        pchMessageStart[0] = 0x77;
        pchMessageStart[1] = 0xe3;
        pchMessageStart[2] = 0xfb;
        pchMessageStart[3] = 0x39;
        vAlertPubKey = ParseHex("04bfa2d910a41c95891760d7c66d8e19b01dd89ac772a1c5b3de57116774bac0a3dabcbc7bba1f00e862ba5fafd23f15e95e1ff1de596bab8bbedb422b8b8d7cc4");
        nDefaultPort = 34513;
        nEnforceBlockUpgradeMajority = 51;
        nRejectBlockOutdatedMajority = 75;
        nToCheckBlockUpgradeMajority = 100;
        nMinerThreads = 0;
        nTargetTimespan = 1 * 60; // p2p: 1 day
        nTargetSpacing = 1 * 60;  // p2p: 1 minute
        nLastPOWBlock = 200;
        nMaturity = 30;
        nMasternodeCountDrift = 4;
        nModifierUpdateBlock = 1;
        nMaxMoneyOut = 21000000 * COIN;

        //! Modify the testnet genesis block so the timestamp is valid for a later start.
        genesis.nTime = 1543178983;
        genesis.nNonce = 21203930;

        hashGenesisBlock = genesis.GetHash();
        assert(hashGenesisBlock == uint256("0x00000eac517dfa680f10e1fa4c3c1f9cca2235d4f5213ff7a98e80c79f6a24b8"));

        vFixedSeeds.clear();
        vSeeds.clear();

        // Testnet p2p addresses start with 'u'
        base58Prefixes[PUBKEY_ADDRESS] = std::vector<unsigned char>(1, 55);
        // Testnet p2p script addresses start with 'v'
        base58Prefixes[SCRIPT_ADDRESS] = std::vector<unsigned char>(1, 196);
        // Testnet private keys start with  'u' or 'v'
        base58Prefixes[SECRET_KEY] = std::vector<unsigned char>(1, 196);
        // Testnet p2p BIP32 pubkeys start with 'tpub' (Bitcoin defaults)
        base58Prefixes[EXT_PUBLIC_KEY] = boost::assign::list_of(0x04)(0x35)(0x87)(0xCF).convert_to_container<std::vector<unsigned char> >();
        // Testnet p2p BIP32 prvkeys start with 'tprv' (Bitcoin defaults)
        base58Prefixes[EXT_SECRET_KEY] = boost::assign::list_of(0x04)(0x35)(0x83)(0x94).convert_to_container<std::vector<unsigned char> >();
        // Testnet p2p BIP44 coin type is '1' (All coin's testnet default)
        base58Prefixes[EXT_COIN_TYPE] = boost::assign::list_of(0x80)(0x00)(0x00)(0x01).convert_to_container<std::vector<unsigned char> >();

        convertSeed6(vFixedSeeds, pnSeed6_test, ARRAYLEN(pnSeed6_test));

        fMiningRequiresPeers = true;
        fAllowMinDifficultyBlocks = false;
        fDefaultConsistencyChecks = false;
        fRequireStandard = false;
        fMineBlocksOnDemand = false;
        fTestnetToBeDeprecatedFieldRPC = true;

        nPoolMaxTransactions = 2;
        strSporkKey = "045e78985673c92bab40b2197a5a8d8cc32c0f3ebbd28d50696235b66d1b30a7949e0603058b465d66e07c6450ddad596fdaf2e3bfc46806c0fa66d94bc9150c1c";
        strMasternodePoolDummyAddress = "VWRSmn8QshzHJcKEbnoDf65DwgD3xStMtJ";
        nStartMasternodePayments = genesis.nTime + 14400; // 4 hours after genesis
        nBudget_Fee_Confirmations = 3; // Number of confirmations for the finalization fee. We have to make this very short
                                       // here because we only have a 8 block finalization window on testnet
    }
    const Checkpoints::CCheckpointData& Checkpoints() const
    {
        return dataTestnet;
    }
};
static CTestNetParams testNetParams;

/**
 * Regression test
 */
class CRegTestParams : public CTestNetParams
{
public:
    CRegTestParams()
    {
        networkID = CBaseChainParams::REGTEST;
        strNetworkID = "regtest";
        strNetworkID = "regtest";
        pchMessageStart[0] = 0x62;
        pchMessageStart[1] = 0xd6;
        pchMessageStart[2] = 0x2d;
        pchMessageStart[3] = 0x84;
        nSubsidyHalvingInterval = 1500;
        nEnforceBlockUpgradeMajority = 750;
        nRejectBlockOutdatedMajority = 950;
        nToCheckBlockUpgradeMajority = 1000;
        nMinerThreads = 1;
        nTargetTimespan = 24 * 60 * 60; // p2p: 1 day
        nTargetSpacing = 1 * 60;        // p2p: 1 minutes
        bnProofOfWorkLimit = ~uint256(0) >> 1;
        genesis.nTime = 1543178984;
        genesis.nBits = 0x1e0ffff0;
        genesis.nNonce = 23091664;

        hashGenesisBlock = genesis.GetHash();
        nDefaultPort = 34516;
        assert(hashGenesisBlock == uint256("0x000005229c457f766c6e873b402d6e45d8e1130772898003947e21365b63612e"));

        vFixedSeeds.clear(); //! Regtest mode doesn't have any fixed seeds.
        vSeeds.clear();      //! Regtest mode doesn't have any DNS seeds.

        fMiningRequiresPeers = false;
        fAllowMinDifficultyBlocks = true;
        fDefaultConsistencyChecks = true;
        fRequireStandard = false;
        fMineBlocksOnDemand = true;
        fTestnetToBeDeprecatedFieldRPC = false;
    }
    const Checkpoints::CCheckpointData& Checkpoints() const
    {
        return dataRegtest;
    }
};
static CRegTestParams regTestParams;

/**
 * Unit test
 */
class CUnitTestParams : public CMainParams, public CModifiableParams
{
public:
    CUnitTestParams()
    {
        networkID = CBaseChainParams::UNITTEST;
        strNetworkID = "unittest";
        nDefaultPort = 49120;
        vFixedSeeds.clear(); //! Unit test mode doesn't have any fixed seeds.
        vSeeds.clear();      //! Unit test mode doesn't have any DNS seeds.

        fMiningRequiresPeers = false;
        fDefaultConsistencyChecks = true;
        fAllowMinDifficultyBlocks = false;
        fMineBlocksOnDemand = true;
    }

    const Checkpoints::CCheckpointData& Checkpoints() const
    {
        // UnitTest share the same checkpoints as MAIN
        return data;
    }

    //! Published setters to allow changing values in unit test cases
    virtual void setSubsidyHalvingInterval(int anSubsidyHalvingInterval) { nSubsidyHalvingInterval = anSubsidyHalvingInterval; }
    virtual void setEnforceBlockUpgradeMajority(int anEnforceBlockUpgradeMajority) { nEnforceBlockUpgradeMajority = anEnforceBlockUpgradeMajority; }
    virtual void setRejectBlockOutdatedMajority(int anRejectBlockOutdatedMajority) { nRejectBlockOutdatedMajority = anRejectBlockOutdatedMajority; }
    virtual void setToCheckBlockUpgradeMajority(int anToCheckBlockUpgradeMajority) { nToCheckBlockUpgradeMajority = anToCheckBlockUpgradeMajority; }
    virtual void setDefaultConsistencyChecks(bool afDefaultConsistencyChecks) { fDefaultConsistencyChecks = afDefaultConsistencyChecks; }
    virtual void setAllowMinDifficultyBlocks(bool afAllowMinDifficultyBlocks) { fAllowMinDifficultyBlocks = afAllowMinDifficultyBlocks; }
    virtual void setSkipProofOfWorkCheck(bool afSkipProofOfWorkCheck) { fSkipProofOfWorkCheck = afSkipProofOfWorkCheck; }
};
static CUnitTestParams unitTestParams;


static CChainParams* pCurrentParams = 0;

CModifiableParams* ModifiableParams()
{
    assert(pCurrentParams);
    assert(pCurrentParams == &unitTestParams);
    return (CModifiableParams*)&unitTestParams;
}

const CChainParams& Params()
{
    assert(pCurrentParams);
    return *pCurrentParams;
}

CChainParams& Params(CBaseChainParams::Network network)
{
    switch (network) {
    case CBaseChainParams::MAIN:
        return mainParams;
    case CBaseChainParams::TESTNET:
        return testNetParams;
    case CBaseChainParams::REGTEST:
        return regTestParams;
    case CBaseChainParams::UNITTEST:
        return unitTestParams;
    default:
        assert(false && "Unimplemented network");
        return mainParams;
    }
}

void SelectParams(CBaseChainParams::Network network)
{
    SelectBaseParams(network);
    pCurrentParams = &Params(network);
}

bool SelectParamsFromCommandLine()
{
    CBaseChainParams::Network network = NetworkIdFromCommandLine();
    if (network == CBaseChainParams::MAX_NETWORK_TYPES)
        return false;

    SelectParams(network);
    return true;
}
