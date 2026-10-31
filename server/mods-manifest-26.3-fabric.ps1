# Fabric 26.3 server mod manifest.
# Generated from the official Modrinth API: one pinned build per project for
# Minecraft 26.3 and the Fabric loader. Update deliberately when upgrading.

$Mods = @(
    [pscustomobject]@{
        Name = 'fabric-api-0.165.0+26.3.jar'
        Url = 'https://cdn.modrinth.com/data/P7dR8mSH/versions/EQKgpeKu/fabric-api-0.165.0%2B26.3.jar'
        Sha512 = '0a4b8a14e847b71567b557b43d906c2167fa263eeeef37454a821ba286996e3da1616dc2d9647736d28a250d5ecf400541cae808359b29a62324a8a6f2ad5e30'
        Required = $true
        Purpose = 'Fabric API dependency'
        Project = 'P7dR8mSH'
    }
    [pscustomobject]@{
        Name = 'essential_commands-0.42.0-mc26.3.jar'
        Url = 'https://cdn.modrinth.com/data/6VdDUivB/versions/KANmt7ie/essential_commands-0.42.0-mc26.3.jar'
        Sha512 = '6edda40084a85446817e1c393f8ea0a386300762c553990ee2bf613a93623f883be752824635f3d7f1d2a89c7b247cc246afd18a1e0d293ff022433b301e180e'
        Required = $true
        Purpose = 'Essential server commands for Fabric'
        Project = '6VdDUivB'
    }
    [pscustomobject]@{
        Name = 'ec-core-1.3.0-mc26.3.jar'
        Url = 'https://cdn.modrinth.com/data/6VdDUivB/versions/KANmt7ie/ec-core-1.3.0-mc26.3.jar'
        Sha512 = 'df10d2ec6bef1ed726d2ec6a656edb0c441d3db26da311cd195dd21b62a1a2e144a7f74573ced5bce149829dcde830b2e8c3f28fea2a9a034f7e7c52bfd86f47'
        Required = $true
        Purpose = 'Required Essential Commands core dependency'
        Project = '6VdDUivB'
    }
    [pscustomobject]@{
        Name = 'InvView-1.4.22-26.3+.jar'
        Url = 'https://cdn.modrinth.com/data/jrDKjZP7/versions/uySsk7v8/InvView-1.4.22-26.3%2B.jar'
        Sha512 = 'a7e21e1833b581cfdcd7b5096c3654ab5a3f7acb8e62dcaa91b0930009063abe407fb0de6031345c0f839e958f3a1f11f9984d8c3ed43aa2bf2542000429a09f'
        Required = $true
        Purpose = 'Server-side inventory and ender-chest administration tools for Fabric'
        Project = 'jrDKjZP7'
    }
    [pscustomobject]@{
        Name = 'OfflineCommands-1.0.3+26.3.jar'
        Url = 'https://cdn.modrinth.com/data/rkgXkDl7/versions/iF2JEqDe/OfflineCommands-1.0.3%2B26.3.jar'
        Sha512 = '2b6805f0ac2c0c74acc7da73a7edcbb42049960ef2a27bb1682481364bb9913d1bc8fd99b56603e072e4b2045a43fce7029aea4e260df16a51b345f54c35e1a6'
        Required = $true
        Purpose = 'Run commands on offline players for Fabric'
        Project = 'rkgXkDl7'
    }
    [pscustomobject]@{
        Name = 'Geyser-Fabric-2.12.1-b1277.jar'
        Url = 'https://cdn.modrinth.com/data/wKkoqHrH/versions/Wy38iD8B/Geyser-Fabric-2.12.1-b1277.jar'
        Sha512 = '75cb46b17959f788c0a81ea132c1684ccb9f375c78b875d7fc7e750fef8b600a0961313ea461e38cb417e98c21e8ff6be2f53bcd0ed721c95051c8f2fe20a027'
        Required = $true
        Purpose = 'Java/Bedrock protocol bridge'
        Project = 'wKkoqHrH'
    }
    [pscustomobject]@{
        Name = 'Floodgate-Fabric-2.2.7-b69.jar'
        Url = 'https://cdn.modrinth.com/data/bWrNNfkb/versions/m9eO07Zi/Floodgate-Fabric-2.2.7-b69.jar'
        Sha512 = '9185fc96c0f301ee0867d83065c210277062ad3d1536e9d4231263fa32ed3223d008268c48de9e00f0e9a2240a2c45c438934d01efa40b1b523b0d072eb322d5'
        Required = $true
        Purpose = 'Bedrock authentication bridge'
        Project = 'bWrNNfkb'
    }
    [pscustomobject]@{
        Name = 'lithium-fabric-0.26.3+mc26.3.jar'
        Url = 'https://cdn.modrinth.com/data/gvQqBUqZ/versions/fWv5bnZk/lithium-fabric-0.26.3%2Bmc26.3.jar'
        Sha512 = '2ca92fb530135d2baddf0ba4cc4f93976234876a38c4aa02b487b2552400f005afcfbeebf5373fb4396fe2020537a42d7597b8da5a52b904355ef51d5fef07ad'
        Required = $true
        Purpose = 'Game-logic optimization'
        Project = 'gvQqBUqZ'
    }
    [pscustomobject]@{
        Name = 'ferritecore-9.0.0-fabric.jar'
        Url = 'https://cdn.modrinth.com/data/uXXizFIs/versions/d5ddUdiB/ferritecore-9.0.0-fabric.jar'
        Sha512 = 'd81fa97e11784c19d42f89c2f433831d007603dd7193cee45fa177e4a6a9c52b384b198586e04a0f7f63cd996fed713322578bde9a8db57e1188854ae5cbe584'
        Required = $true
        Purpose = 'Memory optimization'
        Project = 'uXXizFIs'
    }
    [pscustomobject]@{
        Name = 'krypton-0.3.2.jar'
        Url = 'https://cdn.modrinth.com/data/fQEb0iXm/versions/UugdIYJw/krypton-0.3.2.jar'
        Sha512 = 'd1d57ebd41395b75b01f130cd9503eb8d208212424a399ff9f367f50be8fbc1c6472442b33c686e777c3148f6a609520e8fb732c755157c358cb207fd4d1123a'
        Required = $true
        Purpose = 'Network optimization'
        Project = 'fQEb0iXm'
    }
    [pscustomobject]@{
        Name = 'servercore-fabric-1.5.20+26.3.jar'
        Url = 'https://cdn.modrinth.com/data/4WWQxlQP/versions/LCG1Bm84/servercore-fabric-1.5.20%2B26.3.jar'
        Sha512 = 'abe1f806ea587971faf7de826e18b07314a4a9e690f64a4c3a54e7f61c3e6f4792633b13a917252bd8de154cec39da6619110d83799cf533450c5b4cac7a8448'
        Required = $true
        Purpose = 'Server performance controls'
        Project = '4WWQxlQP'
    }
    [pscustomobject]@{
        Name = 'async-fabric-0.2.5+alpha-26.3.jar'
        Url = 'https://cdn.modrinth.com/data/vEC2jm6I/versions/gcduhoHv/async-fabric-0.2.5%2Balpha-26.3.jar'
        Sha512 = 'dc7662973c1493ccd29ccf390583192bc49d33782dfd5245002427d160a2752fb6b4b09e9e1c7a3dd0f3f373454ed0ea4f9ae9a23752994dcb389662506489dc'
        Required = $true
        Purpose = 'Experimental asynchronous entity processing; test carefully for compatibility'
        Project = 'vEC2jm6I'
    }
    [pscustomobject]@{
        Name = 'fabric-carpet-26.3+v260915.jar'
        Url = 'https://cdn.modrinth.com/data/TQTTVgYE/versions/yt9oDFOj/fabric-carpet-26.3%2Bv260915.jar'
        Sha512 = '7a479ba69eb5049cb94365d5044bd58c9f970c50b3484861fe3675f1917f7c99c1b1f50a5e01bdd9ded940d76a995539009a3656e05be2f513f20ec14de991a7'
        Required = $true
        Purpose = 'Technical and redstone tools'
        Project = 'TQTTVgYE'
    }
    [pscustomobject]@{
        Name = 'linksinchat-1.3.2+26.3-1.jar'
        Url = 'https://cdn.modrinth.com/data/klpvLefw/versions/m7ISLjXq/linksinchat-1.3.2%2B26.3-1.jar'
        Sha512 = 'f3ed5684c62112b79d4509029e1d8eb6ad84298f4389a3efdb15818557158e727b3d03869a83c222473d4fa0db46c56fb4824dea3fae0327e5f884f63e498584'
        Required = $true
        Purpose = 'Clickable links and link whisper commands in server chat'
        Project = 'klpvLefw'
    }
    [pscustomobject]@{
        Name = 'collective-26.3.0-8.70.jar'
        Url = 'https://cdn.modrinth.com/data/e0M1UDsY/versions/sJPRBKdS/collective-26.3.0-8.70.jar'
        Sha512 = '6e19d0ef9583bd4af3fc79967bcff92044ea27445d0126104a5012ee912cdfb3bcf304a97419363ad2f0b6060e72f07c484a32023ecf9247dfe685a2c8060d77'
        Required = $true
        Purpose = 'Required Collective library for Welcome Message'
        Project = 'e0M1UDsY'
    }
    [pscustomobject]@{
        Name = 'welcomemessage-26.3.0-2.9.jar'
        Url = 'https://cdn.modrinth.com/data/DMK2eYu7/versions/EdUUq0em/welcomemessage-26.3.0-2.9.jar'
        Sha512 = '2e12aa704e28340bfa4fb2c450b339dd77f71c7666bb4f18167f476f2ade0aa3c57a8e23147258a8c22b8a57b78472db2ec92fc3c4f6b34664e22d8a2979e09d'
        Required = $true
        Purpose = 'Configurable server-side welcome messages for Fabric'
        Project = 'DMK2eYu7'
    }
    [pscustomobject]@{
        Name = 'NoChatReports-FABRIC-26.3-v2.21.0.jar'
        Url = 'https://cdn.modrinth.com/data/qQyHxfxd/versions/6g96avt2/NoChatReports-FABRIC-26.3-v2.21.0.jar'
        Sha512 = 'ee7733f50049b9f847f3abeea7a1dcb429932a5e9be16e9ab4e1d7db752ff7e43f5a449f8d971fa60e6f96917e509a05d86a03399a71be2749449ef91ec39f67'
        Required = $true
        Purpose = 'Prevents chat reporting and removes secure-chat signing requirements on the server'
        Project = 'qQyHxfxd'
    }
    [pscustomobject]@{
        Name = 'imfast-FABRIC-26.3-1.0.6.jar'
        Url = 'https://cdn.modrinth.com/data/PaUMOeP0/versions/Utpunxwi/imfast-FABRIC-26.3-1.0.6.jar'
        Sha512 = '6617e6438e56240d47baa7a89a71644bfff6b5da4d99efd019352d26194850593461a13ee7405de0b97dc9204adcb9b9a3e27143277336a58fc3a5f19433ebe2'
        Required = $true
        Purpose = 'Removes vanilla moved-too-quickly and moved-wrongly speed limits'
        Project = 'PaUMOeP0'
    }
)
