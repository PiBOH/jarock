# NeoForge 26.3 server mod manifest.
# Generated from the official Modrinth API: one pinned build per project for
# Minecraft 26.3 and the NeoForge loader. Forge and NeoForge mods are not interchangeable.

$Mods = @(
    [pscustomobject]@{
        Name = 'Geyser-Neoforge-2.12.1-b1277.jar'
        Url = 'https://cdn.modrinth.com/data/wKkoqHrH/versions/TEv7uLkr/Geyser-Neoforge-2.12.1-b1277.jar'
        Sha512 = '9d1aa665a0f11eb630376ae7ea8d9560f04fd1456879f7c8d614b1a4d61620be863f7b39f63ed83c6ef5d31e12b825192fa059ac198655c71bde7f9e31481ec9'
        Required = $true
        Purpose = 'Java/Bedrock protocol bridge'
        Project = 'wKkoqHrH'
    }
    [pscustomobject]@{
        Name = 'Floodgate-Neoforge-2.2.7-b69.jar'
        Url = 'https://cdn.modrinth.com/data/bWrNNfkb/versions/9mryDssz/Floodgate-Neoforge-2.2.7-b69.jar'
        Sha512 = '6375d230ebdb937727e4f0b3afcd2d6eb75f530ceb4f87948591cbf64660825282e0311eaf9c874e46e18f2bbb923fefcf071a660882512bea75d95de58c3f73'
        Required = $true
        Purpose = 'Bedrock authentication bridge'
        Project = 'bWrNNfkb'
    }
    [pscustomobject]@{
        Name = 'lithium-neoforge-0.26.3+mc26.3.jar'
        Url = 'https://cdn.modrinth.com/data/gvQqBUqZ/versions/2BP6jqRA/lithium-neoforge-0.26.3%2Bmc26.3.jar'
        Sha512 = '0f184d76b54a3ddeabbb2d664859260fb42cfdb205da9ae4261630cd6b1f0751c4113f38523c6ff9b496b5b0d766a31c41c7e307ce84131696752dae8db9e9bd'
        Required = $true
        Purpose = 'Game-logic optimization'
        Project = 'gvQqBUqZ'
    }
    [pscustomobject]@{
        Name = 'ferritecore-9.0.0-neoforge.jar'
        Url = 'https://cdn.modrinth.com/data/uXXizFIs/versions/LtVvw4uS/ferritecore-9.0.0-neoforge.jar'
        Sha512 = 'e96a99ac5539f56a1f4cd109d62b668ebd5283f0068491ede956f52e67023beba7abe2e40021499352ffc41ead950bebcabce7792352249a1b45c5dccb3cf99c'
        Required = $true
        Purpose = 'Memory optimization'
        Project = 'uXXizFIs'
    }
    [pscustomobject]@{
        Name = 'servercore-neoforge-1.5.20+26.3.jar'
        Url = 'https://cdn.modrinth.com/data/4WWQxlQP/versions/bfczZvad/servercore-neoforge-1.5.20%2B26.3.jar'
        Sha512 = '158d459149c38969666ce3957292f7747d3a368605600dcad88490feb2b54f9805141e957384ad46b7d2406c1005cdb42a697a60cd2d1d71bae0e6f183478167'
        Required = $true
        Purpose = 'Server performance controls'
        Project = '4WWQxlQP'
    }
    [pscustomobject]@{
        Name = 'async-neoforge-0.2.5+alpha-26.3.jar'
        Url = 'https://cdn.modrinth.com/data/vEC2jm6I/versions/iP3BMAMC/async-neoforge-0.2.5%2Balpha-26.3.jar'
        Sha512 = 'c96a4d0565ea9ff9d2bad4c1fb82b765b1a4e0c1690833b2d9a34de4681e942cee63a459ec92c3a719e739b685523d3120c1c7df0ffd3f382b4d83f8189aa1b4'
        Required = $true
        Purpose = 'Experimental asynchronous entity processing; test carefully for compatibility'
        Project = 'vEC2jm6I'
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
        Purpose = 'Configurable server-side welcome messages for NeoForge'
        Project = 'DMK2eYu7'
    }
    [pscustomobject]@{
        Name = 'NoChatReports-NEOFORGE-26.3-v2.21.0.jar'
        Url = 'https://cdn.modrinth.com/data/qQyHxfxd/versions/RzXG2uJB/NoChatReports-NEOFORGE-26.3-v2.21.0.jar'
        Sha512 = '754354a68e596f67d9f0b2e42819abfab4fb950a9009396a8216e080652e6f1e2d1719dbb9987933fb63c43a78d110df2148591952b187313b9e0f1dc2910b92'
        Required = $true
        Purpose = 'Prevents chat reporting and removes secure-chat signing requirements on the server'
        Project = 'qQyHxfxd'
    }
    [pscustomobject]@{
        Name = 'imfast-NEOFORGE-26.3-1.0.6.jar'
        Url = 'https://cdn.modrinth.com/data/PaUMOeP0/versions/di7bweEC/imfast-NEOFORGE-26.3-1.0.6.jar'
        Sha512 = '9695b319c833ab6e5747ed388f2c586bdd2788a978f8e538c4a13c09c3549b00135237ebd2da69a3429f304b28553e0ac3dfafa9d2267b0374ef93db37f6c869'
        Required = $true
        Purpose = 'Removes vanilla moved-too-quickly and moved-wrongly speed limits'
        Project = 'PaUMOeP0'
    }
)
