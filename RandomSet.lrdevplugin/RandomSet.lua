local LrApplication = import 'LrApplication'
local LrTasks = import 'LrTasks'

local activeCatalog = LrApplication:activeCatalog()

LrTasks.startAsyncTask(function()
		activeCatalog:withWriteAccessDo(
			'Create Random Set',
			function()
				
				local randomSet = activeCatalog:createCollectionSet('Random Set', nil, true)
				local randomCollection = activeCatalog:createCollection(os.date('%Y-%m-%d %H-%M-%S'), randomSet, true)
				
				local allPhotos = activeCatalog:getAllPhotos()
				
				Count = 0
				for Index, Value in pairs( allPhotos ) do
					Count = Count + 1
				end
				
				math.randomseed(os.time())
				for i = 1, 50, 1
				do
					index = math.random(1, Count)
					randomCollection:addPhotos({allPhotos[index]})
				end
				
			end,
			{ timeout = 10 })
end)