local LrApplication = import 'LrApplication'
local LrTasks = import 'LrTasks'
--local LrLogger = import 'LrLogger'

local logger = LrLogger('randomset')
logger:enable('print')

local activeCatalog = LrApplication:activeCatalog()

LrTasks.startAsyncTask(function()
		activeCatalog:withWriteAccessDo(
			'Create Random Set',
			function()
				


				local randomSet = activeCatalog:createCollectionSet('Random Set', nil, true)
				local randomCollection = activeCatalog:createCollection(os.date('%Y-%m-%d %H-%M-%S'), randomSet, true)

				--[[
				Add all photos from active sources to a table,
				counting while we go.
				--]]				
				local activeSources = activeCatalog:getActiveSources()
				local photoCount = 0
				local allPhotos = {}
				for i, source in pairs(activeSources) do
					local sourcePhotos = source:getPhotos()
					for j, photo in pairs(sourcePhotos) do
						photoCount = photoCount + 1
						allPhotos[photoCount] = photo
					end
				end
				
				--[[
				Add random photos to the set until we hit our goal or
				the set count equals the number of photos available.
				--]]
				math.randomseed(os.time())
				local setCount = 0
				local set = {}
				while setCount < 50 and setCount <= photoCount
				do
					index = math.random(1, photoCount)
					if set[index] == nil then
						set[index] = allPhotos[index]
						setCount = setCount + 1
						--logger:tracef('Photo #%i with index %i added to set.', setCount, index)
					end
				end
				for i, v in pairs(set) do
					randomCollection:addPhotos({v})
				end
				
			end,
			{ timeout = 10 })
end)