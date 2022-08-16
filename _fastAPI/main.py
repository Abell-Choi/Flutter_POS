### FAST API MAIN ###

# TODO #
# 1. db file constructor
# 2. how to communicated data
# 3. using query or custom?

# 1. file constructor
# log File -> fileName : uuid.json
# {
#   'updatetime' : <Stirng> updateTime,
#   'goodsLists' : <List> <Item Lists>,
#   'isKakaoPay' : <bool> true or false,
#   'uuid' : <String> == fileName
# }
#
# goods File -> fileName : goodsCode.json
# {
#  'updateTime'" " <String> updateTime;
#  'code' : <int> itemCode;
#  'img' : <String> Image url;
#  'name' : <String> item name;
#  'count' : <int> 'not using for this file';
#  'price' : <int> item Price;
#  'isValid' : <bool> can selling this item;
# }

# 2. how to communicated data
# 2-1. saving, loading -> sqlite
# 2-2. communicate framework -> fastAPI

# 3. using query or custom -> custom (function? POST?)