-- mget('key', {'user1', 'user2'}) --> for those users
-- mget('key')                     --> all users

local result = {}

local key, users = ...
assert(key, 'need key')

local uvars = os.glob('uvars/*.json')
for i=1, #uvars do
  uvars[i] = uvars[i]:match('.+/([^%.]+)%.json')
end

users = users or uvars
for i=1, #users do
  local u = users[i]:lower()
  result[u] = etc.get(key, u)
end

return result
