hook.Add( "GetFallDamage", "RealisticDamage", function( ply, speed )
    return ( speed / 8 )
end )