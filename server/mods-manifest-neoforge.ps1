# NeoForge 26.2 server mod manifest.
# URLs and SHA-512 hashes are pinned for reproducible first-run setup.
# Forge and NeoForge mods are not interchangeable.

$Mods = @(
    [pscustomobject]@{
        Name = 'Geyser-Neoforge-2.11.1-b1209.jar'
        Url = 'https://cdn.modrinth.com/data/wKkoqHrH/versions/OKLO7VVS/Geyser-Neoforge-2.11.1-b1209.jar'
        Sha512 = '33ed23a835f963b2ca7dbb033a3c9d3c9b61396970fa5fbf5a696963b738bcee30697b0e039513e00197dbc7908554c3ce87d56b33b3dd6a9d477063cd1d2ae1'
        Required = $true
        Purpose = 'Java/Bedrock protocol bridge'
    }
    [pscustomobject]@{
        Name = 'Floodgate-Neoforge-2.2.6-b67.jar'
        Url = 'https://cdn.modrinth.com/data/bWrNNfkb/versions/F88UjBuf/Floodgate-Neoforge-2.2.6-b67.jar'
        Sha512 = 'c8f861db73165337055e81d2d6d7521e92e0d218c99d4b9a4936dfefd92377e97ef10857aad927830bbdf54b9893c055d4c8f33555b7fb0071e646b0108318c5'
        Required = $true
        Purpose = 'Bedrock authentication bridge'
    }
    [pscustomobject]@{
        Name = 'lithium-neoforge-0.25.3+mc26.2.jar'
        Url = 'https://cdn.modrinth.com/data/gvQqBUqZ/versions/J9CowDXK/lithium-neoforge-0.25.3%2Bmc26.2.jar'
        Sha512 = '56f5299bc84084f2112abf61ea58bad101a7495cc8a1db3df0963494bce096e474c0bde0975831c30ec15c5c977451a31f82de90a09b769c94df91dbcb9b9286'
        Required = $true
        Purpose = 'Game-logic optimization'
    }
    [pscustomobject]@{
        Name = 'ferritecore-9.0.0-neoforge.jar'
        Url = 'https://cdn.modrinth.com/data/uXXizFIs/versions/LtVvw4uS/ferritecore-9.0.0-neoforge.jar'
        Sha512 = 'e96a99ac5539f56a1f4cd109d62b668ebd5283f0068491ede956f52e67023beba7abe2e40021499352ffc41ead950bebcabce7792352249a1b45c5dccb3cf99c'
        Required = $true
        Purpose = 'Memory optimization'
    }
    [pscustomobject]@{
        Name = 'servercore-neoforge-1.5.19+26.2.jar'
        Url = 'https://cdn.modrinth.com/data/4WWQxlQP/versions/88gv0DMz/servercore-neoforge-1.5.19%2B26.2.jar'
        Sha512 = '1fa8868ca7208a22b156155e23dc9700f2964b872b6d659ef9d58cb707bce8e8b73b18db65b4616c41a71eb9dd12ef2735f1ada0ac0f31c28582d8937470fb12'
        Required = $true
        Purpose = 'Server performance controls'
    }
    [pscustomobject]@{
        Name = 'collective-26.2.0-8.39.jar'
        Url = 'https://cdn.modrinth.com/data/e0M1UDsY/versions/M75JwjyS/collective-26.2.0-8.39.jar'
        Sha512 = 'e27620080ae53460b00cabacaff409a960e0d6c6811b7e3519d5461cb62654e0016161eed914352171af56191b70a97c79320b3ef29c0636b74a0471c2398055'
        Required = $true
        Purpose = 'Required Collective library for Welcome Message'
    }
    [pscustomobject]@{
        Name = 'welcomemessage-26.2.0-2.8.jar'
        Url = 'https://cdn.modrinth.com/data/DMK2eYu7/versions/HaUYHekm/welcomemessage-26.2.0-2.8.jar'
        Sha512 = 'c4e6aca35e5da10f1a3a7e9432a1946bc0e5c8e36c8357bd6c7cbb66cb0c7d99402bb55a9679828223d0353b356ec05ee998e6035c165b03318fe93a6fe3d113'
        Required = $true
        Purpose = 'Configurable server-side welcome messages for NeoForge 26.2'
    }
    [pscustomobject]@{
        Name = 'NoChatReports-NEOFORGE-26.2-v2.20.1.jar'
        Url = 'https://cdn.modrinth.com/data/qQyHxfxd/versions/k9fqrSE6/NoChatReports-NEOFORGE-26.2-v2.20.1.jar'
        Sha512 = '782b4b081c5d8bdd19139894feacc9c48b6fb025856e904c2bb9ee84438734de96eb5540f471e57830ecb92df8f18f6da20a1b619c4806b16f06780250999d03'
        Required = $true
        Purpose = 'Prevents chat reporting and removes secure-chat signing requirements on the server'
    }
    [pscustomobject]@{
        Name = 'imfast-NEOFORGE-26.2-1.0.3.jar'
        Url = 'https://cdn.modrinth.com/data/PaUMOeP0/versions/Hu3Yov2Y/imfast-NEOFORGE-26.2-1.0.3.jar'
        Sha512 = '01280a82eb092551d996d60b6520e84849c1f79812fce689119276fa9fa7118e976f07bc244f94bb54f16d9c354ba10590dec699e6d5c10c271484bead0b8c06'
        Required = $true
        Purpose = 'Removes vanilla moved-too-quickly and moved-wrongly speed limits'
    }
)
