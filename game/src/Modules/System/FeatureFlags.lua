local featureFlags = {}
featureFlags.debug = not love.filesystem.isFused()   -- debug stuff will not appear on compiled games --
featureFlags.demo = false
featureFlags.videoStats = featureFlags.debug

return featureFlags
