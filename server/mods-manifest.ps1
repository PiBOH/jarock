# Fabric 26.2 server mod manifest.
# URLs and SHA-512 hashes are pinned so a fresh checkout is reproducible.
# Update this file deliberately when upgrading the server stack.

$Mods = @(
    [pscustomobject]@{
        Name = 'fabric-api-0.156.0+26.2.jar'
        Url = 'https://cdn.modrinth.com/data/P7dR8mSH/versions/3gT0I5vt/fabric-api-0.156.0%2B26.2.jar'
        Sha512 = '5bbc436d07f836cd90b88287e2ef27f1cd67e26185b2cd4a62cb2ae850eb74e5edbbc7ba7772e92ea91ebf35b263f8815421e3d5e7d2836cb28993ba1d534816'
        Required = $true
        Purpose = 'Fabric API dependency'
    }
    [pscustomobject]@{
        Name = 'Geyser-Fabric-2.11.1-b1209.jar'
        Url = 'https://cdn.modrinth.com/data/wKkoqHrH/versions/qx0y8XK1/Geyser-Fabric-2.11.1-b1209.jar'
        Sha512 = '4f894794ae3d3e6ffc1dfc43a231bcc13767958ba2c922018065faab737d2d34a8c65b33355cdb8a8759a760909634bd611acb6cbb37a0651a52d27aa4d32511'
        Required = $true
        Purpose = 'Java/Bedrock protocol bridge'
    }
    [pscustomobject]@{
        Name = 'Floodgate-Fabric-2.2.6-b67.jar'
        Url = 'https://cdn.modrinth.com/data/bWrNNfkb/versions/urOFTrVX/Floodgate-Fabric-2.2.6-b67.jar'
        Sha512 = 'd6ecacfbf1c31171317792783754c4f58414508a8fd1aa23b9e3da5da9fe450a6e6e882e39e862cb5f1df38d2d97be8465a39857fe4b78c1cf89934230a71205'
        Required = $true
        Purpose = 'Bedrock authentication bridge'
    }
    [pscustomobject]@{
        Name = 'lithium-fabric-0.25.3+mc26.2.jar'
        Url = 'https://cdn.modrinth.com/data/gvQqBUqZ/versions/f7vZ0VWU/lithium-fabric-0.25.3%2Bmc26.2.jar'
        Sha512 = '148b638f3c6229fbaf487120a2344a0af5e411a5aa6533d5db9d75da0a8c0d8304f63eb4cca13f4d03b2c9b4c23d559dd74c1d832422ef8a3087bd005e62a8bd'
        Required = $true
        Purpose = 'Game-logic optimization'
    }
    [pscustomobject]@{
        Name = 'ferritecore-9.0.0-fabric.jar'
        Url = 'https://cdn.modrinth.com/data/uXXizFIs/versions/d5ddUdiB/ferritecore-9.0.0-fabric.jar'
        Sha512 = 'd81fa97e11784c19d42f89c2f433831d007603dd7193cee45fa177e4a6a9c52b384b198586e04a0f7f63cd996fed713322578bde9a8db57e1188854ae5cbe584'
        Required = $true
        Purpose = 'Memory optimization'
    }
    [pscustomobject]@{
        Name = 'krypton-0.3.1.jar'
        Url = 'https://cdn.modrinth.com/data/fQEb0iXm/versions/5WeL0Nkz/krypton-0.3.1.jar'
        Sha512 = 'b8d9af34cd0050493afb8a6232cb8f785daa9d8887b7045f6e6a53c6bb9b5ffc4318fd9b0347a940eacfeba4773f10cb80ae0be1e79ce4c1888f96eda21e564e'
        Required = $true
        Purpose = 'Network optimization'
    }
    [pscustomobject]@{
        Name = 'servercore-fabric-1.5.19+26.2.jar'
        Url = 'https://cdn.modrinth.com/data/4WWQxlQP/versions/edrtnY9v/servercore-fabric-1.5.19%2B26.2.jar'
        Sha512 = 'aa4cfc93f8e02172910302444330e37713dfcf2047d28e55eb7323a3cd5d51493374a0959aa3e626ec2bf43fc707a755508b83454bb34b6d57d65c069929074b'
        Required = $true
        Purpose = 'Server performance controls'
    }
    [pscustomobject]@{
        Name = 'fabric-carpet-26.2+v260616.jar'
        Url = 'https://cdn.modrinth.com/data/TQTTVgYE/versions/bGrLxJ8v/fabric-carpet-26.2%2Bv260616.jar'
        Sha512 = '8b8fac6979bd3153f5cfb4faa6bab52e1357eab814492a6658f3c0e1ac2856ad37a626c0a03a0839c39abb7bf56661f77b09d05d10ac01173bcdd373a33c6265'
        Required = $true
        Purpose = 'Technical and redstone tools'
    }
    [pscustomobject]@{
        Name = 'linksinchat-1.3.1+26.2.jar'
        Url = 'https://cdn.modrinth.com/data/klpvLefw/versions/UjY4hWon/linksinchat-1.3.1%2B26.2.jar'
        Sha512 = '9cbd4eb2b26b518920a2df78c22c95c998ded2f36b6a524881f96f22a2f1a111790791283d32613db8eb71f48e71b30625114c3eaf9d134cd57b776163290067'
        Required = $true
        Purpose = 'Clickable links and link whisper commands in server chat'
    }
    [pscustomobject]@{
        Name = 'welcome_awa-fabric-26.2-2.4.jar'
        Url = 'https://cdn.modrinth.com/data/fC8CQ1bz/versions/Y8JZbT7F/welcome_awa-fabric-26.2-2.4.jar'
        Sha512 = '981c813ae53a230b49b8e2a33f83cb6fac810847baffaef43369f3caeccace19b7d5f578093277d656f5e5817ec18139485b8d76bee8ec6329279cc6eaa388c5'
        Required = $true
        Purpose = 'Colored server-side join welcome messages with player placeholders'
    }
    [pscustomobject]@{
        Name = 'imfast-FABRIC-26.2-1.0.3.jar'
        Url = 'https://cdn.modrinth.com/data/PaUMOeP0/versions/nD5sET2x/imfast-FABRIC-26.2-1.0.3.jar'
        Sha512 = '664606eb41dbf13385ec82545c30a7b118bd263393325c29a6a6eef6e0a390555c194e0c15df64c18d7f477344c423e518e67b481d5c9171fd5c7fb36795341b'
        Required = $true
        Purpose = 'Removes vanilla moved-too-quickly and moved-wrongly speed limits'
    }
)
