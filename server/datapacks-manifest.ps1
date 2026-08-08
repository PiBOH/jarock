# Loader-neutral datapack manifest for Minecraft 26.2.
# The bootstrap copies this verified archive into the configured world's datapacks folder.
# Update deliberately only after checking the official Modrinth version and SHA-512.

$Datapacks = @(
    [pscustomobject]@{
        Name = 'BetterMultiplayerSleep-1.1.0-1.21.11+.zip'
        Url = 'https://cdn.modrinth.com/data/LxB45e67/versions/amCbDkLY/BetterMultiplayerSleep%201.1.0%201.21.11%2B.zip'
        Sha512 = '8ecadc28a73bbe12dade19d5dfa0840dc8d28b2bd80c0ef154779063375fb5c96cc7c877c55c627909f2aea2907a30b2a8f2038769d269443f0e1689f7f3017a'
        Required = $true
        Purpose = 'Allows one player to sleep through the night on the server'
    }
)
