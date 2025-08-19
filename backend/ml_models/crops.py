def crop(crop_name):
    crop_data= {
    "bajra": [
        "../static/images/bajra.jpg",
        "Rajasthan, Uttar Pradesh, Haryana, Gujarat, Maharashtra",
        "kharif",
        "Saudi Arabia, UAE, Yemen, USA"
    ],
    "barley": [
        "../static/images/barley.jpg",
        "Rajasthan, Uttar Pradesh, Haryana, Madhya Pradesh, Punjab",
        "rabi",
        "Saudi Arabia, UAE, Nepal, Japan"
    ],
    "jowar": [
        "../static/images/jowar.jpg",
        "Maharashtra, Karnataka, Madhya Pradesh, Andhra Pradesh, Tamil Nadu",
        "both",
        "USA, UAE, Nepal, China"
    ],
    "maize": [
        "../static/images/maize.jpg",
        "Karnataka, Andhra Pradesh, Maharashtra, Rajasthan, Madhya Pradesh",
        "both",
        "Vietnam, Malaysia, Sri Lanka, Bangladesh, UAE"
    ],
    "paddy": [
        "../static/images/paddy.jpg",
        "West Bengal, Punjab, Uttar Pradesh, Andhra Pradesh, Tamil Nadu",
        "kharif",
        "Bangladesh, Saudi Arabia, Iran, Nepal, UAE"
    ],
    "ragi": [
        "../static/images/ragi.jpg",
        "Karnataka, Tamil Nadu, Andhra Pradesh, Odisha, Maharashtra",
        "kharif",
        "USA, UK, Germany, Australia"
    ],
    "wheat": [
        "../static/images/wheat.jpg",
        "Punjab, Haryana, Uttar Pradesh, Madhya Pradesh, Bihar",
        "rabi",
        "Bangladesh, Sri Lanka, UAE, Indonesia, Afghanistan"
    ],
    "betelnut_arceanut": [
        "../static/images/betelnut_arceanut.jpg",
        "Karnataka, Kerala, Assam, Tamil Nadu, Meghalaya",
        "perennial",
        "Nepal, Pakistan, Bangladesh, UAE"
    ],
    "black_pepper": [
        "../static/images/black_pepper.jpg",
        "Kerala, Karnataka, Tamil Nadu",
        "perennial",
        "USA, Germany, UK, Vietnam, UAE"
    ],
    "cardamom": [
        "../static/images/cardamom.jpg",
        "Kerala, Karnataka, Tamil Nadu",
        "perennial",
        "Saudi Arabia, UAE, Kuwait, Qatar, Japan"
    ],
    "chillies_dry": [
        "../static/images/chillies_dry.jpg",
        "Andhra Pradesh, Telangana, Madhya Pradesh, Karnataka, Odisha",
        "both",
        "Vietnam, Thailand, Sri Lanka, Bangladesh, USA"
    ],
    "coriander": [
        "../static/images/coriander.jpg",
        "Rajasthan, Madhya Pradesh, Gujarat, Uttar Pradesh, Tamil Nadu",
        "rabi",
        "Malaysia, Pakistan, Bangladesh, UAE, UK"
    ],
    "cumin": [
        "../static/images/cumin.jpg",
        "Rajasthan, Gujarat",
        "rabi",
        "Vietnam, USA, Bangladesh, UAE, UK"
    ],
    "garlic": [
        "../static/images/garlic.jpg",
        "Madhya Pradesh, Gujarat, Uttar Pradesh, Rajasthan, Odisha",
        "rabi",
        "Bangladesh, Nepal, Malaysia, Sri Lanka, UAE"
    ],
    "ginger_dry": [
        "../static/images/ginger_dry.jpg",
        "Kerala, Karnataka, Orissa, Assam, Meghalaya",
        "kharif",
        "USA, UK, Netherlands, Saudi Arabia, UAE"
    ],
    "tamarind": [
        "../static/images/tamarind.jpg",
        "Tamil Nadu, Maharashtra, Karnataka, Andhra Pradesh, Odisha",
        "perennial",
        "USA, UK, UAE, Saudi Arabia, Germany"
    ],
    "turmeric": [
        "../static/images/turmeric.jpg",
        "Telangana, Andhra Pradesh, Tamil Nadu, Odisha, Maharashtra",
        "kharif",
        "UAE, USA, Iran, Japan, Malaysia"
    ],
    "coir_fibre": [
        "../static/images/coir_fibre.jpg",
        "Kerala, Tamil Nadu, Karnataka, Andhra Pradesh, Odisha",
        "perennial",
        "USA, UK, Germany, Netherlands, Australia"
    ],
    "mesta": [
        "../static/images/mesta.jpg",
        "West Bengal, Bihar, Assam, Andhra Pradesh, Odisha",
        "kharif",
        "Nepal, Bangladesh, Thailand, Vietnam, Philippines"
    ],
    "raw_cotton": [
        "../static/images/raw_cotton.jpg",
        "Gujarat, Maharashtra, Telangana, Andhra Pradesh, Punjab",
        "kharif",
        "Bangladesh, China, Vietnam, Pakistan, Indonesia"
    ],
    "raw_jute": [
        "../static/images/raw_jute.jpg",
        "West Bengal, Bihar, Assam, Meghalaya, Odisha",
        "kharif",
        "Nepal, Bangladesh, UK, USA, Australia"
    ],
    "raw_silk": [
        "../static/images/raw_silk.jpg",
        "Karnataka, West Bengal, Jammu & Kashmir, Tamil Nadu, Assam",
        "perennial",
        "USA, UK, Italy, France, Germany"
    ],
    "raw_wool": [
        "../static/images/raw_wool.jpg",
        "Rajasthan, Jammu & Kashmir, Himachal Pradesh, Uttarakhand, Gujarat",
        "perennial",
        "UK, Italy, Germany, China, USA"
    ],
    "jasmine": [
        "../static/images/jasmine.jpg",
        "Tamil Nadu, Karnataka, Andhra Pradesh, West Bengal",
        "perennial",
        "UAE, Saudi Arabia, USA, Singapore"
    ],
    "marigold": [
        "../static/images/marigold.jpg",
        "Karnataka, Tamil Nadu, West Bengal, Maharashtra, Andhra Pradesh",
        "both",
        "Nepal, Malaysia, Sri Lanka"
    ],
    "rose": [
        "../static/images/rose.jpg",
        "Maharashtra, Karnataka, Tamil Nadu, West Bengal, Uttar Pradesh",
        "perennial",
        "UAE, Saudi Arabia, Netherlands, Germany"
    ],
    "almonds": [
        "../static/images/almonds.jpg",
        "Jammu & Kashmir, Himachal Pradesh",
        "perennial",
        "UAE, Saudi Arabia, Nepal"
    ],
    "amla": [
        "../static/images/amla.jpg",
        "Uttar Pradesh, Madhya Pradesh, Bihar, Rajasthan, Tamil Nadu",
        "perennial",
        "USA, UK, Bangladesh, Nepal"
    ],
    "apple": [
        "../static/images/apple.jpg",
        "Jammu & Kashmir, Himachal Pradesh, Uttarakhand",
        "perennial",
        "Nepal, Bangladesh, UAE, Saudi Arabia"
    ],
    "banana": [
        "../static/images/banana.jpg",
        "Tamil Nadu, Maharashtra, Gujarat, Andhra Pradesh, Karnataka",
        "perennial",
        "UAE, Saudi Arabia, Oman, Iran, Bangladesh"
    ],
    "cashew_nut": [
        "../static/images/cashew_nut.jpg",
        "Kerala, Karnataka, Goa, Maharashtra, Odisha",
        "perennial",
        "UAE, USA, Japan, Netherlands, UK"
    ],
    "coconut_fresh": [
        "../static/images/coconut_fresh.jpg",
        "Kerala, Tamil Nadu, Karnataka, Andhra Pradesh",
        "perennial",
        "UAE, Saudi Arabia, Malaysia, Sri Lanka"
    ],
    "grapes": [
        "../static/images/grapes.jpg",
        "Maharashtra, Karnataka, Andhra Pradesh, Tamil Nadu",
        "perennial",
        "Netherlands, Russia, UK, UAE, Bangladesh"
    ],
    "guava": [
        "../static/images/guava.jpg",
        "Uttar Pradesh, Bihar, Maharashtra, Tamil Nadu, Andhra Pradesh",
        "perennial",
        "UAE, Nepal, Bangladesh, Saudi Arabia"
    ],
    "jackfruit": [
        "../static/images/jackfruit.jpg",
        "Kerala, Tamil Nadu, Assam, West Bengal, Karnataka",
        "perennial",
        "UK, USA, Germany, Singapore"
    ],
    "lemon": [
        "../static/images/lemon.jpg",
        "Andhra Pradesh, Tamil Nadu, Maharashtra, Gujarat, Rajasthan",
        "perennial",
        "UAE, Bangladesh, Nepal, Sri Lanka"
    ],
    "sweet_orange": [
        "../static/images/sweet_orange.jpg",
        "Maharashtra, Andhra Pradesh, Punjab, Karnataka",
        "perennial",
        "Bangladesh, Nepal, UAE, Sri Lanka"
    ],
    "orange": [
        "../static/images/orange.jpg",
        "Maharashtra (Nagpur), Punjab, Madhya Pradesh",
        "perennial",
        "Bangladesh, UAE, Sri Lanka, Nepal"
    ],
    "papaya": [
        "../static/images/papaya.jpg",
        "Andhra Pradesh, Karnataka, Maharashtra, Gujarat, West Bengal",
        "perennial",
        "UAE, Qatar, Nepal, Saudi Arabia"
    ],
    "pear": [
        "../static/images/pear.jpg",
        "Jammu & Kashmir, Himachal Pradesh, Uttarakhand",
        "perennial",
        "Nepal, Bangladesh, UAE"
    ],
    "pineapple": [
        "../static/images/pineapple.jpg",
        "West Bengal, Assam, Kerala, Tripura, Meghalaya",
        "perennial",
        "UAE, Qatar, Saudi Arabia, Nepal"
    ],
    "pomengranate": [
        "../static/images/pomengranate.jpg",
        "Maharashtra, Karnataka, Andhra Pradesh, Tamil Nadu, Gujarat",
        "perennial",
        "Bangladesh, UAE, Saudi Arabia, Netherlands"
    ],
    "sapota": [
        "../static/images/sapota.jpg",
        "Karnataka, Gujarat, Maharashtra, Tamil Nadu, Andhra Pradesh",
        "perennial",
        "UAE, Saudi Arabia, Bangladesh"
    ],
    "walnut": [
        "../static/images/walnut.jpg",
        "Jammu & Kashmir, Himachal Pradesh, Uttarakhand",
        "perennial",
        "USA, UK, Germany, UAE"
    ],
    "fodder": [
        "../static/images/fodder.jpg",
        "Punjab, Haryana, Uttar Pradesh, Maharashtra, Rajasthan",
        "both",
        "Nepal, Bangladesh"
    ],
    "gaur_seed": [
        "../static/images/gaur_seed.jpg",
        "Rajasthan, Gujarat, Haryana",
        "kharif",
        "USA, Germany, China, Japan"
    ],
    "industrial_wood": [
        "../static/images/industrial_wood.jpg",
        "Andhra Pradesh, Telangana, Odisha, Madhya Pradesh",
        "perennial",
        "Nepal, Bangladesh, Sri Lanka"
    ],
    "raw_rubber": [
        "../static/images/raw_rubber.jpg",
        "Kerala, Tripura, Karnataka, Tamil Nadu, Assam",
        "perennial",
        "USA, Germany, Japan, Sri Lanka"
    ],
    "tobacco": [
        "../static/images/tobacco.jpg",
        "Andhra Pradesh, Karnataka, Telangana, Gujarat",
        "both",
        "Belgium, Egypt, Russia, Indonesia, USA"
    ],
    "castor_seed": [
        "../static/images/castor_seed.jpg",
        "Gujarat, Rajasthan, Andhra Pradesh",
        "both",
        "China, Thailand, USA, Netherlands"
    ],
    "copra_coconut": [
        "../static/images/copra_coconut.jpg",
        "Kerala, Tamil Nadu, Karnataka, Andhra Pradesh",
        "perennial",
        "USA, UK, Germany, Malaysia, Sri Lanka"
    ],
    "cotton_seed": [
        "../static/images/cotton_seed.jpg",
        "Gujarat, Maharashtra, Punjab, Haryana, Telangana",
        "kharif",
        "Bangladesh, Vietnam, Pakistan, China"
    ],
    "gingelly_seed_sesamum": [
        "../static/images/gingelly_seed_sesamum.jpg",
        "Uttar Pradesh, Rajasthan, Madhya Pradesh, Tamil Nadu, Andhra Pradesh",
        "kharif",
        "Japan, South Korea, USA, Vietnam"
    ],
    "groundnut_seed": [
        "../static/images/groundnut_seed.jpg",
        "Gujarat, Andhra Pradesh, Tamil Nadu, Maharashtra, Karnataka",
        "kharif",
        "Indonesia, Vietnam, Philippines, Malaysia"
    ],
    "linseed": [
        "../static/images/linseed.jpg",
        "Madhya Pradesh, Uttar Pradesh, Chhattisgarh, Bihar",
        "rabi",
        "Nepal, Bangladesh"
    ],
    "niger_seed": [
        "../static/images/niger_seed.jpg",
        "Odisha, Chhattisgarh, Andhra Pradesh, Madhya Pradesh",
        "kharif",
        "USA, UK, Germany"
    ],
    "rape_mustard_seed": [
        "../static/images/rape_mustard_seed.jpg",
        "Rajasthan, Uttar Pradesh, Haryana, Madhya Pradesh",
        "rabi",
        "Nepal, Bangladesh, UAE"
    ],
    "safflower_kardi_seed": [
        "../static/images/safflower_kardi_seed.jpg",
        "Maharashtra, Karnataka, Andhra Pradesh",
        "rabi",
        "USA, Germany, UK"
    ],
    "soyabean": [
        "../static/images/soyabean.jpg",
        "Madhya Pradesh, Maharashtra, Rajasthan",
        "kharif",
        "Iran, Bangladesh, Vietnam, Thailand, Nepal"
    ],
    "sunflower": [
        "../static/images/sunflower.jpg",
        "Karnataka, Andhra Pradesh, Maharashtra, Punjab",
        "both",
        "Nepal, Bangladesh, UAE"
    ],
    "betel_leaves": [
        "../static/images/betel_leaves.jpg",
        "West Bengal, Odisha, Tamil Nadu, Andhra Pradesh",
        "perennial",
        "UK, USA, Singapore, UAE"
    ],
    "coffee": [
        "../static/images/coffee.jpg",
        "Karnataka, Kerala, Tamil Nadu",
        "perennial",
        "Italy, Germany, Russia, Belgium, USA"
    ],
    "honey": [
        "../static/images/honey.jpg",
        "Punjab, Haryana, West Bengal, Bihar, Uttar Pradesh",
        "perennial",
        "USA, Saudi Arabia, UAE, Bangladesh"
    ],
    "sugarcane": [
        "../static/images/sugarcane.jpg",
        "Uttar Pradesh, Maharashtra, Karnataka, Tamil Nadu, Bihar",
        "perennial",
        "Sri Lanka, Nepal, Bangladesh, Indonesia"
    ],
    "tea": [
        "../static/images/tea.jpg",
        "Assam, West Bengal, Tamil Nadu, Kerala",
        "perennial",
        "Russia, Iran, UK, USA, UAE"
    ],
    "arhar": [
        "../static/images/arhar.jpg",
        "Maharashtra, Karnataka, Uttar Pradesh, Madhya Pradesh",
        "kharif",
        "Sri Lanka, Bangladesh, Nepal"
    ],
    "gram": [
        "../static/images/gram.jpg",
        "Madhya Pradesh, Maharashtra, Rajasthan, Uttar Pradesh",
        "rabi",
        "Bangladesh, Nepal, Pakistan"
    ],
    "masur": [
        "../static/images/masur.jpg",
        "Uttar Pradesh, Madhya Pradesh, Bihar, West Bengal",
        "rabi",
        "Bangladesh, Nepal"
    ],
    "moong": [
        "../static/images/moong.jpg",
        "Rajasthan, Maharashtra, Karnataka, Andhra Pradesh",
        "kharif",
        "Bangladesh, Nepal, Sri Lanka"
    ],
    "peas_chawali": [
        "../static/images/peas_chawali.jpg",
        "Uttar Pradesh, Madhya Pradesh, Bihar, West Bengal",
        "rabi",
        "Nepal, Bangladesh"
    ],
    "rajma": [
        "../static/images/rajma.jpg",
        "Jammu & Kashmir, Uttarakhand, Himachal Pradesh",
        "kharif",
        "USA, UK, UAE"
    ],
    "urad": [
        "../static/images/urad.jpg",
        "Maharashtra, Andhra Pradesh, Madhya Pradesh, Tamil Nadu",
        "kharif",
        "Nepal, Bangladesh, Sri Lanka"
    ],
    "cotton_yarn": [
        "../static/images/cotton_yarn.jpg",
        "Tamil Nadu, Gujarat, Maharashtra, Punjab",
        "perennial",
        "China, Bangladesh, Vietnam, Sri Lanka"
    ],
    "woollen_yarn": [
        "../static/images/woollen_yarn.jpg",
        "Rajasthan, Punjab, Uttar Pradesh, Himachal Pradesh",
        "perennial",
        "USA, UK, Germany"
    ],
    "beans": [
        "../static/images/beans.jpg",
        "Karnataka, Maharashtra, Himachal Pradesh",
        "rabi",
        "UAE, UK, Bangladesh"
    ],
    "bittergourd": [
        "../static/images/bittergourd.jpg",
        "Uttar Pradesh, Maharashtra, West Bengal",
        "kharif",
        "UAE, UK, Malaysia"
    ],
    "bottlegourd": [
        "../static/images/bottlegourd.jpg",
        "Uttar Pradesh, Bihar, West Bengal",
        "kharif",
        "UAE, Nepal, Bangladesh"
    ],
    "brinjal": [
        "../static/images/brinjal.jpg",
        "West Bengal, Odisha, Bihar, Maharashtra",
        "both",
        "Nepal, Bangladesh, UAE"
    ],
    "cabbage": [
        "../static/images/cabbage.jpg",
        "West Bengal, Bihar, Odisha, Karnataka",
        "rabi",
        "Nepal, Bangladesh, UAE"
    ],
    "carrot": [
        "../static/images/carrot.jpg",
        "Punjab, Haryana, Karnataka, Uttar Pradesh",
        "rabi",
        "UAE, Qatar, Nepal"
    ],
    "cauliflower": [
        "../static/images/cauliflower.jpg",
        "West Bengal, Bihar, Uttar Pradesh",
        "rabi",
        "Nepal, Bangladesh"
    ],
    "cucumber": [
        "../static/images/cucumber.jpg",
        "Uttar Pradesh, Punjab, Haryana",
        "kharif",
        "UAE, Oman"
    ],
    "drumstick": [
        "../static/images/drumstick.jpg",
        "Tamil Nadu, Andhra Pradesh, Karnataka",
        "perennial",
        "USA, UK, Malaysia, Singapore"
    ],
    "gingerfresh": [
        "../static/images/gingerfresh.jpg",
        "Kerala, Karnataka, Assam, Meghalaya",
        "kharif",
        "USA, UK, Germany"
    ],
    "ladyfinger": [
        "../static/images/ladyfinger.jpg",
        "Uttar Pradesh, West Bengal, Bihar",
        "kharif",
        "UAE, UK, Saudi Arabia"
    ],
    "onion": [
        "../static/images/onion.jpg",
        "Maharashtra, Karnataka, Madhya Pradesh, Gujarat",
        "rabi",
        "Bangladesh, Malaysia, Sri Lanka, UAE"
    ],
    "peasgreen": [
        "../static/images/peasgreen.jpg",
        "Uttar Pradesh, Bihar, Madhya Pradesh",
        "rabi",
        "Nepal, UAE, Bangladesh"
    ],
    "pointedgourd": [
        "../static/images/pointedgourd.jpg",
        "West Bengal, Bihar, Assam",
        "kharif",
        "Nepal, Bangladesh"
    ],
    "potato": [
        "../static/images/potato.jpg",
        "Uttar Pradesh, West Bengal, Bihar, Punjab",
        "rabi",
        "Nepal, Sri Lanka, Bangladesh, UAE"
    ],
    "pumpkin": [
        "../static/images/pumpkin.jpg",
        "West Bengal, Odisha, Bihar, Uttar Pradesh",
        "kharif",
        "Nepal, Bangladesh"
    ],
    "radish": [
        "../static/images/radish.jpg",
        "Punjab, Haryana, Uttar Pradesh, West Bengal",
        "rabi",
        "UAE, Qatar"
    ],
    "sweetpotato": [
        "../static/images/sweetpotato.jpg",
        "Odisha, Uttar Pradesh, West Bengal",
        "kharif",
        "Nepal, Bangladesh"
    ],
    "tapioca": [
        "../static/images/tapioca.jpg",
        "Kerala, Tamil Nadu, Andhra Pradesh",
        "perennial",
        "USA, UK, Malaysia"
    ],
    "tomato": [
        "../static/images/tomato.jpg",
        "Andhra Pradesh, Karnataka, Maharashtra, Odisha",
        "both",
        "UAE, Sri Lanka, Nepal, Bangladesh"
    ]
}
    return crop_data[crop_name] 


commodity_dict={

    "bajra": "static/dataset/price_trend/Bajra.csv",
    "barley": "static/dataset/price_trend/Barley.csv",
    "jowar": "static/dataset/price_trend/Jowar.csv",
    "maize": "static/dataset/price_trend/Maize.csv",
    "paddy": "static/dataset/price_trend/Paddy.csv",
    "ragi": "static/dataset/price_trend/Ragi.csv",
    "wheat": "static/dataset/price_trend/Wheat.csv",
    "betelnut_arceanut": "static/dataset/price_trend/Betelnut_Arecanut.csv",
    "black_pepper": "static/dataset/price_trend/Black_Pepper.csv",
    "cardamom": "static/dataset/price_trend/Cardamom.csv",
    "chillies_dry": "static/dataset/price_trend/ChilliesDry.csv",
    "coriander": "static/dataset/price_trend/Coriander.csv",
    "cumin": "static/dataset/price_trend/Cumin.csv",
    "garlic": "static/dataset/price_trend/Garlic.csv",
    "ginger_dry": "static/dataset/price_trend/GingerDry.csv",
    "tamarind": "static/dataset/price_trend/Tamarind.csv",
    "turmeric": "static/dataset/price_trend/Turmeric.csv",
    "coir_fibre": "static/dataset/price_trend/Coir_Fibre.csv",
    "mesta": "static/dataset/price_trend/Mesta.csv",
    "raw_cotton": "static/dataset/price_trend/Raw_Cotton.csv",
    "raw_jute": "static/dataset/price_trend/Raw_Jute.csv",
    "raw_silk": "static/dataset/price_trend/Raw_Silk.csv",
    "raw_wool": "static/dataset/price_trend/Raw_Wool.csv",
    "jasmine": "static/dataset/price_trend/Jasmine.csv",
    "marigold": "static/dataset/price_trend/Marigold.csv",
    "rose": "static/dataset/price_trend/Rose.csv",
    "almonds": "static/dataset/price_trend/Almonds.csv",
    "amla": "static/dataset/price_trend/Amla.csv",
    "apple": "static/dataset/price_trend/Apple.csv",
    "banana": "static/dataset/price_trend/Banana.csv",
    "cashew_nut": "static/dataset/price_trend/Cashew_nut.csv",
    "coconut_fresh": "static/dataset/price_trend/Coconut_Fresh.csv",
    "grapes": "static/dataset/price_trend/Grapes.csv",
    "guava": "static/dataset/price_trend/Guava.csv",
    "jackfruit": "static/dataset/price_trend/Jackfruit.csv",
    "lemon": "static/dataset/price_trend/Lemon.csv",
    "sweet_orange": "static/dataset/price_trend/Sweet_Orange.csv",
    "orange": "static/dataset/price_trend/Orange.csv",
    "papaya": "static/dataset/price_trend/Papaya.csv",
    "pear": "static/dataset/price_trend/Pear.csv",
    "pineapple": "static/dataset/price_trend/Pineapple.csv",
    "pomengranate": "static/dataset/price_trend/Pomengranate.csv",
    "sapota": "static/dataset/price_trend/Sapota.csv",
    "walnut": "static/dataset/price_trend/Walnut.csv",
    "fodder": "static/dataset/price_trend/Fodder.csv",
    "gaur_seed": "static/dataset/price_trend/Gaur_Seed.csv",
    "industrial_wood": "static/dataset/price_trend/Industrial_wood.csv",
    "raw_rubber": "static/dataset/price_trend/Raw_Rubber.csv",
    "tobacco": "static/dataset/price_trend/Tobacco.csv",
    "castor_seed": "static/dataset/price_trend/Castor_Seed.csv",
    "copra_coconut": "static/dataset/price_trend/Copra_Coconut.csv",
    "cotton_seed": "static/dataset/price_trend/Cotton_Seed.csv",
    "gingelly_seed_sesamum": "static/dataset/price_trend/Gingelly_Seed.csv",
    "groundnut_seed": "static/dataset/price_trend/Groundnut_Seed.csv",
    "linseed": "static/dataset/price_trend/Linseed.csv",
    "niger_seed": "static/dataset/price_trend/Niger_Seed.csv",
    "rape_mustard_seed": "static/dataset/price_trend/Rape_Mustard_Seed.csv",
    "safflower_kardi_seed": "static/dataset/price_trend/Safflower.csv",
    "soyabean": "static/dataset/price_trend/Soyabean.csv",
    "sunflower": "static/dataset/price_trend/Sunflower.csv",
    "betel_leaves": "static/dataset/price_trend/Betel_Leaves.csv",
    "coffee": "static/dataset/price_trend/Coffee.csv",
    "honey": "static/dataset/price_trend/Honey.csv",
    "sugarcane": "static/dataset/price_trend/Sugarcane.csv",
    "tea": "static/dataset/price_trend/Tea.csv",
    "arhar": "static/dataset/price_trend/Arhar.csv",
    "gram": "static/dataset/price_trend/Gram.csv",
    "masur": "static/dataset/price_trend/Masur.csv",
    "moong": "static/dataset/price_trend/Moong.csv",
    "peas_chawali": "static/dataset/price_trend/Peas_Chawali.csv",
    "rajma": "static/dataset/price_trend/Rajma.csv",
    "urad": "static/dataset/price_trend/Urad.csv",
    "cotton_yarn": "static/dataset/price_trend/Cotton_yarn.csv",
    "woollen_yarn": "static/dataset/price_trend/Woollen_yarn.csv",
    "beans": "static/dataset/price_trend/Beans.csv",
    "bittergourd": "static/dataset/price_trend/Bitter_gourd.csv",
    "bottlegourd": "static/dataset/price_trend/Bottle_gourd.csv",
    "brinjal": "static/dataset/price_trend/Brinjal.csv",
    "cabbage": "static/dataset/price_trend/Cabbage.csv",
    "carrot": "static/dataset/price_trend/Carrot.csv",
    "cauliflower": "static/dataset/price_trend/Cauliflower.csv",
    "cucumber": "static/dataset/price_trend/Cucumber.csv",
    "drumstick": "static/dataset/price_trend/Drumstick.csv",
    "gingerfresh": "static/dataset/price_trend/Ginger_Fresh.csv",
    "ladyfinger": "static/dataset/price_trend/Ladyfinger.csv",
    "onion": "static/dataset/price_trend/Onion.csv",
    "peasgreen": "static/dataset/price_trend/Peas_Green.csv",
    "pointedgourd": "static/dataset/price_trend/Pointed_gourd.csv",
    "potato": "static/dataset/price_trend/Potato.csv",
    "pumpkin": "static/dataset/price_trend/Pumpkin.csv",
    "radish": "static/dataset/price_trend/Radish.csv",
    "sweetpotato": "static/dataset/price_trend/Sweet_Potato.csv",
    "tapioca": "static/dataset/price_trend/Tapioca.csv",
    "tomato": "static/dataset/price_trend/Tomato.csv"
}



# base_price= {
#     "bajra":1500,
#     "barley":1500,
#     "jowar":2000,
#     "maize":1650,
#     "paddy":2300,
#     "ragi":2411,
#     "wheat":2445,
#     "betelnut_arceanut":10000,
#     "black_pepper":3500,
#     "cardamom":255000,
#     "chillies_dry":4000,
#     "coriander":300,
#     "cumin":16000,
#     "garlic":4000,
#     "ginger_dry":1850,
#     "tamarind":2450,
#     "turmeric":8000,
#     "coir_fibre":2500,
#     "mesta":5000,
#     "raw_cotton":2500,
#     "raw_jute":5300,
#     "raw_silk":5000,
#     "raw_wool":4925,
#     "jasmine":40000,
#     "marigold":5000,
#     "rose":6000,
#     "almonds":75000,
#     "amla":2000,
#     "apple":2500,
#     "banana":1200,
#     "cashew_nut":16000,
#     "coconut_fresh":3000,
#     "grapes":7000,
#     "guava":4000,
#     "jackfruit":1000,
#     "lemon":1810,
#     "sweet_orange":4000,
#     "orange":4000,
#     "papaya":800,
#     "pear":15000,
#     "pineapple":2500,
#     "pomengranate":8000,
#     "sapota":2000,
#     "walnut":10000,
#     "fodder":27000,
#     "gaur_seed":3800,
#     "industrial_wood":550,
#     "raw_rubber":17100,
#     "tobacco":7500,
#     "castor_seed":4500,
#     "copra_coconut":13000,
#     "cotton_seed":6750,
#     "gingelly_seed_sesamum":5200,
#     "groundnut_seed":5075,
#     "linseed":5000,
#     "niger_seed":7450,
#     "rape_mustard_seed":4000,
#     "safflower_kardi_seed":5250,
#     "soyabean":1751,
#     "sunflower":4000,
#     "betel_leaves":10000,
#     "coffee":26500,
#     "honey":10000,
#     "sugarcane":300,
#     "tea":27000,
#     "arhar":2000,
#     "gram":800,
#     "masur":7340,
#     "moong":1526,
#     "peas_chawali":1000,
#     "rajma":3000,
#     "urad":9500,
#     "cotton_yarn":2500,
#     "woollen_yarn":4925,
#     "beans":7278,
#     "bittergourd":3588.94,
#     "bottlegourd":1772.75,
#     "brinjal":2486,
#     "cabbage":2880,
#     "carrot":3000,
#     "cauliflower":300,
#     "cucumber":300,
#     "drumstick":2728,
#     "gingerfresh":1250,
#     "ladyfinger":300,
#     "onion":3667,
#     "peasgreen":1500,
#     "pointedgourd":2000,
#     "potato":300,
#     "pumpkin":1400,
#     "radish":1600,
#     "sweetpotato":3600,
#     "tapioca":1200,
#     "tomato":2250
# }

base_price= {
    "bajra":1500,
    "barley":1500,
    "jowar":2000,
    "maize":1650,
    "paddy":2300,
    "ragi":2411,
    "wheat":2445,
    "betelnut_arceanut":10000,
    "black_pepper":3500,
    "cardamom":255000,
    "chillies_dry":4000,
    "coriander":300,
    "cumin":16000,
    "garlic":4000,
    "ginger_dry":1850,
    "tamarind":2450,
    "turmeric":8000,
    "coir_fibre":2500,
    "mesta":5000,
    "raw_cotton":2500,
    "raw_jute":5300,
    "raw_silk":5000,
    "raw_wool":4925,
    "jasmine":40000,
    "marigold":5000,
    "rose":6000,
    "almonds":75000,
    "amla":2000,
    "apple":2500,
    "banana":1200,
    "cashew_nut":16000,
    "coconut_fresh":3000,
    "grapes":7000,
    "guava":4000,
    "jackfruit":1000,
    "lemon":1810,
    "sweet_orange":4000,
    "orange":4000,
    "papaya":800,
    "pear":15000,
    "pineapple":2500,
    "pomengranate":8000,
    "sapota":2000,
    "walnut":10000,
    "fodder":27000,
    "gaur_seed":3800,
    "industrial_wood":550,
    "tobacco":7500,
    "castor_seed":4500,
    "copra_coconut":13000,
    "cotton_seed":6750,
    "gingelly_seed_sesamum":5200,
    "groundnut_seed":5075,
    "linseed":5000,
    "niger_seed":7450,
    "rape_mustard_seed":4000,
    "safflower_kardi_seed":5250,
    "soyabean":1751,
    "sunflower":4000,
    "betel_leaves":10000,
    "coffee":26500,
    "honey":10000,
    "sugarcane":300,
    "tea":27000,
    "arhar":2000,
    "gram":800,
    "masur":7340,
    "moong":1526,
    "peas_chawali":1000,
    "rajma":3000,
    "urad":9500,
    "cotton_yarn":2500,
    "woollen_yarn":4925,
    "beans":7278,
    "bittergourd":3588.94,
    "bottlegourd":1772.75,
    "brinjal":2486,
    "cabbage":2880,
    "carrot":3000,
    "cauliflower":300,
    "cucumber":300,
    "drumstick":2728,
    "gingerfresh":1250,
    "ladyfinger":300,
    "onion":3667,
    "peasgreen":1500,
    "pointedgourd":2000,
    "potato":300,
    "pumpkin":1400,
    "radish":1600,
    "sweetpotato":3600,
    "tapioca":1200,
    "tomato":2250
}
