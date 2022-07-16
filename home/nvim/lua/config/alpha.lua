local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

logo_rinnegan = {
   "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
   "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣤⣶⣶⣶⣾⣿⣿⣿⣿⣷⣶⣶⣶⣤⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
   "⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
   "⠀⠀⠀⠀⠀⠀⢀⣠⣾⣿⣿⣿⣿⡿⢿⣛⣭⣽⣶⣶⣿⣿⣿⣿⣿⣿⣶⣶⣯⣭⣛⡻⢿⣿⣿⣿⣿⣷⣤⡀⠀⠀⠀⠀⠀⠀",
   "⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⡿⣛⣵⣾⣿⣿⣿⣿⣿⣿⣿⠿⠿⠿⠿⣿⣿⣿⣿⣿⣿⣿⣷⣮⣛⢿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀",
   "⠀⠀⠀⣰⣿⣿⣿⣿⠟⣩⣾⠿⣿⣿⣿⠿⣛⣭⣷⣶⣿⣿⣿⣿⣿⣿⣶⣾⣭⣛⠿⣿⣿⣿⣿⣷⣌⠻⣿⣿⣿⣿⣆⠀⠀⠀",
   "⠀⠀⣼⣿⣿⣿⡿⢫⣾⠋⠠⠿⠿⣫⣵⣿⣿⣿⣿⣿⣿⡟⠋⠉⢉⣙⣻⣿⣿⣿⣿⣶⣝⠿⠟⠛⠿⣷⣝⢿⣿⣿⣿⣧⠀⠀",
   "⠀⣸⣿⣿⣿⡿⣱⣿⣿⡀⠀⠀⠀⢸⣿⣿⣿⣿⣿⡿⣟⠀⠀⠀⠀⣻⠿⣿⣿⣿⣿⣿⡇⠀⠀⠀⢠⡈⣿⣎⢿⣿⣿⣿⣧⠀",
   "⢠⣿⣿⣿⣿⢣⣿⣿⣿⣿⢆⣶⣶⣿⣿⣿⣿⢟⣵⣿⣿⣷⣶⣶⣾⣿⣿⣮⡻⣿⣿⣿⣿⣷⣶⡔⣿⣷⣿⣿⡜⣿⣿⣿⣿⡄",
   "⢸⣿⣿⣿⣿⢸⣿⣿⣿⡿⣸⣿⣿⣿⣿⣿⡏⣾⣿⣿⣿⡿⠛⠛⢿⣿⣿⣿⣿⡸⣿⣿⣿⣿⣿⣧⢻⣿⣿⣿⣇⣿⣿⣿⣿⡇",
   "⢸⣿⣿⣿⣿⢸⣿⣿⣿⣧⢻⣿⣿⡿⣿⣿⠏⠛⠿⣿⣿⣧⣀⣀⣼⣿⣿⠿⠛⠡⢿⣿⣿⣿⣿⡿⣸⣿⣿⣿⡟⣼⣿⣿⣿⡇",
   "⠸⣿⣿⣿⣿⡸⣿⣿⣿⣿⡼⣿⣿⣷⡈⠁⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣏⠀⠀⠀⠀⢻⣿⣿⣿⢇⣿⣿⣿⣿⢇⣿⣿⣿⣿⡇",
   "⠀⢻⣿⣿⣿⣧⢻⣿⣿⣿⣷⡝⣿⣿⣿⣶⣶⣶⣶⣯⣟⣛⣿⣿⣛⣻⣭⣶⣶⠆⣠⣾⣿⣿⢏⣾⣿⣿⣿⡟⣼⣿⣿⣿⡿⠀",
   "⠀⠈⢿⣿⣿⣿⣧⡻⣿⣿⣿⣿⣮⡻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢟⣵⣿⣿⣿⣿⢟⣼⣿⣿⣿⡿⠁⠀",
   "⠀⠀⠈⢻⣿⣿⣿⣿⣎⠻⣿⣿⣿⣿⣷⣭⣛⠿⣿⣿⣿⡿⠿⠿⢿⣿⣿⣿⠿⣟⣯⣶⣿⣿⣿⣿⠿⣣⣿⣿⣿⣿⡟⠁⠀⠀",
   "⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣮⣛⢿⣿⣿⣿⣿⣿⣷⣶⣿⡀⠀⠀⠀⣽⣶⣾⣿⣿⣿⣿⣿⡿⣟⣵⣾⣿⣿⣿⡿⠋⠀⠀⠀⠀",
   "⠀⠀⠀⠀⠀⠀⠙⠿⣿⣿⣿⣿⣷⣮⣽⣛⠿⢿⣿⣿⣭⣉⣀⣤⣾⣿⣿⣿⡿⠿⣛⣯⣵⣾⣿⣿⣿⣿⠿⠋⠀⠀⠀⠀⠀⠀",
   "⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⢿⣿⣿⣿⣿⣿⣿⣶⣶⣿⣯⣭⣭⣽⣿⣶⣶⣿⣿⣿⣿⣿⣿⣿⠿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀",
   "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
   "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ",
}

logo_meta = {
   "⠀⠀⠀⠀⠀⢀⣠⣴⣶⣶⣶⣶⣤⣀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣶⣶⣶⣦⣤⡀⠀⠀⠀⠀⠀",
   "⠀⠀⠀⣠⣶⣿⣿⣿⡿⠿⠿⣿⣿⣿⣿⣦⡀⠀⣠⣴⣿⡿⠟⠛⠛⠛⠿⣿⣿⣷⣄⠀⠀⠀",
   "⠀⠀⣴⣿⣿⣿⠋⠁⠀⠀⠀⠀⠉⠻⣿⣿⣿⣶⣿⡿⠋⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣧⡀⠀",
   "⠀⣾⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠈⣻⣿⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣷⡀",
   "⣸⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⢿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣇",
   "⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⡿⠁⠈⢻⣿⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿",
   "⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⠟⠀⠀⠀⠀⠹⣿⣿⣿⣧⡀⠀⠀⠀⠀⠀⠀⣿⣿⣿",
   "⣿⣿⣿⣧⠀⠀⠀⠀⢀⣴⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣄⠀⠀⠀⠀⢠⣿⣿⣿",
   "⠘⣿⣿⣿⣷⣶⣶⣶⣿⣿⣿⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣷⣶⣶⣶⣿⣿⣿⠃",
   "⠀⠈⠙⠿⠿⣿⣿⠿⠟⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⠿⢿⣿⠿⠿⠛⠁⠀",
}

logo_meta_pe = {
   "⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣴⡶⠾⠟⠛⠛⠛⠛⠛⠛⠻⠷⢶⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀",
   "⠀⠀⠀⠀⠀⣠⣴⠾⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠷⣦⣄⣀⠀⠀⠀⠀",
   "⠀⠀⠀⣠⣾⠟⠁⠀⠀⠀⠀⣀⣤⣴⡶⠶⠶⠶⠶⢶⣦⣤⣀⠀⠀⠀⠀⠸⣿⣿⡿⠀⠀⠀",
   "⠀⢀⣾⠟⠁⠀⠀⠀⣠⣴⠿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠿⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀",
   "⢀⣾⠏⠀⠀⠀⣶⣿⣿⡅⠀⠀⠀⢀⣠⣤⣤⣤⣤⣄⡀⠀⠀⠀⠈⠛⠛⠛⠛⠛⠛⠻⣷⡀",
   "⣼⣿⠀⠀⠀⠀⠈⠉⠉⠀⠀⢀⣴⡿⠋⠁⠀⠀⠈⠙⢿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣧",
   "⣿⡷⠶⠶⠶⠶⠶⠶⠶⠶⠶⢾⣿⠀⠀⠀⠀⠀⠀⠀⠀⣿⡷⠶⠶⠶⠶⠶⠶⠶⠶⠶⢾⣿",
   "⢻⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣧⡀⠀⠀⠀⠀⣀⣼⡿⠁⠀⠀⢀⣀⠀⠀⠀⠀⠀⣾⡟",
   "⠘⣿⣦⣤⣤⣤⣤⣤⣤⡀⠀⠀⠀⠉⠛⠿⠷⠾⠿⠛⠉⠀⠀⠀⢰⣿⣿⡿⠀⠀⠀⣰⣿⠃",
   "⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⡿⠋⠀⠀⠀⠀⣰⡿⠃⠀",
   "⠀⠀⠀⣶⣿⣷⡄⠀⠀⠀⠈⠙⠻⠷⢶⣶⣤⣤⣶⠶⠾⠟⠋⠁⠀⠀⠀⠀⣠⣾⠟⠁⠀⠀",
   "⠀⠀⠀⠈⠉⠙⠿⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⠿⠋⠁⠀⠀⠀⠀",
   "⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠷⢶⣦⣤⣤⣄⣀⣀⣠⣤⣤⣴⡶⠿⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀",
   "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
}

logo_sun = {
   "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣶⣾⣿⣷⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
   "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⠻⢿⣿⣿⣷⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
   "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⣷⣄⠘⢿⣿⣿⣷⣦⡙⢿⣿⣿⣿⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
   "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣌⠻⢿⣿⣿⣷⣦⡙⢿⣿⣿⣿⣦⣌⠻⣿⣿⣿⣷⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
   "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠰⢿⣿⣿⣷⣤⡙⢿⣿⣿⣿⣦⣌⠻⣿⣿⣿⣷⣌⠙⢿⣿⣿⣿⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
   "⠀⠀⠀⠀⠀⠀⠀⠀⣠⣶⣿⣷⣤⠙⢿⣿⣿⣿⣦⣈⠻⣿⣿⣿⣷⣌⡙⢿⣿⣿⣿⣦⡙⠛⣡⣾⣿⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀",
   "⠀⠀⠀⠀⠀⢀⣤⣾⣿⣿⡿⠟⣡⣶⣦⣈⠻⣿⣿⣿⣷⣌⠙⢿⣿⣿⣿⡄⠙⠻⡿⢋⣴⣾⣿⣿⡿⠟⣡⣶⣤⡀⠀⠀⠀⠀⠀",
   "⠀⠀⠀⣀⣴⣿⣿⣿⡿⢋⣤⣾⣿⣿⡿⠟⠁⠈⠙⢿⣿⣿⣿⣦⣿⣿⣿⡟⠀⣀⣴⣿⣿⣿⡿⢋⣤⣾⣿⣿⡿⠟⠀⠀⠀⠀⠀",
   "⠀⣠⣾⣿⣿⣿⠟⣁⣴⣿⣿⣿⡿⢋⣤⣶⣾⣿⣶⣦⡙⠻⢿⣿⡿⠿⠋⣠⣾⣿⣿⣿⠟⣁⣴⣿⣿⣿⡿⢋⣠⣶⣶⣶⣦⣄⠀",
   "⣾⣿⣿⡿⠛⣡⣾⣿⣿⣿⠟⣁⣴⣿⣿⣿⡿⢿⣿⣿⣿⠀⠀⠀⠀⠀⣾⣿⣿⡿⠋⣡⣾⣿⣿⣿⠟⣁⣴⣿⣿⣿⡿⢿⣿⣿⣧",
   "⢻⣿⣿⣿⣿⣿⣿⡿⠋⣡⣾⣿⣿⣿⠟⣁⣴⣿⣿⣿⠟⠀⢀⣀⠀⠀⢿⣿⣿⣷⣿⣿⣿⡿⠛⣡⣾⣿⣿⣿⠟⣁⣴⣿⣿⣿⠟",
   "⠀⠉⠛⠛⠛⠛⢉⣴⣿⣿⣿⡿⠋⣡⣾⣿⣿⣿⠟⢁⣴⣿⣿⣿⣿⣷⣦⡙⠻⠿⠿⠛⢉⣴⣿⣿⣿⡿⠋⣡⣾⣿⣿⣿⠟⠁⠀",
   "⠀⠀⠀⠀⠀⢴⣿⣿⣿⠟⢋⣴⣾⣿⣿⡿⠋⠁⠀⢸⣿⣿⣿⡛⠿⣿⣿⣿⣦⣄⠠⣶⣿⣿⣿⠟⢋⣴⣿⣿⣿⡿⠋⠁⠀⠀⠀",
   "⠀⠀⠀⠀⠀⠀⠙⠟⣡⣴⣿⣿⣿⠿⢋⣴⣿⣷⣦⡈⢿⣿⣿⣿⣦⣈⠻⣿⣿⣿⣷⣌⡛⠟⣡⣴⣿⣿⣿⠿⠋⠀⠀⠀⠀⠀⠀",
   "⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⠟⣡⣶⣦⡙⠿⣿⣿⣿⣦⣌⠻⣿⣿⣿⣷⣄⡙⢿⣿⣿⣿⣦⡙⢿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀",
   "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠿⣿⣿⣿⣦⣈⠻⣿⣿⣿⣷⣌⠙⢿⣿⣿⣿⣦⡙⠻⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
   "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣷⣌⠙⢿⣿⣿⣿⣦⡙⠻⣿⣿⣿⣷⠌⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
   "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⢿⣿⣿⣿⣦⡙⠻⣿⣿⣿⡆⠈⠻⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
   "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⣿⣿⣿⣶⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
   "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠻⠿⠿⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
}

logos = {
   logo_meta,
   logo_meta_pe,
   logo_sun,
   logo_rinnegan,
}

-- TODO: Cycle or randomly choose one of these logos
dashboard.section.header.val = logo_meta

alpha.setup(dashboard.config)
