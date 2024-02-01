# final: prev: {
#   git = prev.git.override {
#     userName = "andrew";
#     userEmail = "andrew.le197@gmail.com";
#     signing.key = "";
#     lfs = {
#       enable = true; };
#     extraConfig = {
#       commit.gpgsign = false;
#     };
#   };
# }
# self: super: with super; {
#   git = {
#     userName = "andrew";
#     userEmail = "andrew.le197@gmail.com";
#     signing.key = "";
#     lfs = {
#       enable = true; };
#     extraConfig = {
#       commit.gpgsign = false;
#     };
#   };
# }
