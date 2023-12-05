NAME        = fractol

#   COMANDOS
CC			= gcc 
RM			= rm -rf
SRC			= srcs/fractol
CFLAGS		= -g -Wall -Wextra -Werror

#	EXTRAS
RED    		= \033[1;31m
GREEN  		= \033[1;32m
YELLOW 		= \033[1;33m
BLUE   		= \033[1;34m
CYAN   		= \033[1;36m
RESET  		= \033[0m
UNAME  		= $(shell uname -s)

#   SOURCE FILES
CFILES 		=	srcs/fractol/main.c \
				srcs/fractol/options1.c \
				srcs/fractol/options2.c \
				srcs/fractol/aux_maths.c \
				srcs/fractol/aux_other.c \
				srcs/fractol/aux_hooks.c \
				srcs/fractol/pixel_equations.c \
				srcs/fractol/image_related.c \
				srcs/fractol/hook_related.c \
				srcs/fractol/color_related.c \
				srcs/fractol/help_related.c 

#   OBJECT FILES
OFILES 		= $(CFILES:.c=.o)

#	LOCATIONS
HPATH		= includes
LIBS        = libs
FTPRINTF    = srcs/ft_printf

## MLX LOCATION AND COMPILATION FLAGS : ACCORDING TO SYSTEM
ifeq ($(UNAME), Darwin)
MLX     	=  ./$(LIBS)/miniLibX/
MLXFLAGS 	=  -O3 -L $(MLX) -lmlx -framework OpenGL -framework AppKit
MLXLIB		= $(MLX)/libmlx.a
else
MLX			= ./$(LIBS)/miniLibX_X11
MLXFLAGS 	= -L $(MLX) -lmlx -lXext -lX11 -lm
MLXLIB		= $(MLX)/libmlx_Linux.a
endif

#   LIBRARIES
FTPRINTFLIB	= libftprintf.a
LPFLAGS		= $(LIBS)/$(FTPRINTFLIB)

all : $(NAME)

$(NAME) : $(OFILES)
	@echo "$(YELLOW)*******make -C $(FTPRINTF)********$(RESET)"
	@[ -e $(LPFLAGS) ] && echo "$(CYAN)$(FTPRINTF) $(GREEN) already compiled!$(RESET)"  || make -C $(FTPRINTF)  
	@echo "$(YELLOW)*******make -C $(MLX)********$(RESET)"
	@[ -e $(MLXLIB) ] && echo "$(CYAN)$(MLXLIB) $(GREEN) already compiled!$(RESET)" || make -C $(MLX) 
	@echo "$(GREEN)*******ALL********$(RESET)"
	@$(CC) $^ -o $@ $(MLXFLAGS) $(LPFLAGS)  

$(SRC)/%.o: $(SRC)/%.c $(HPATH)/%.h
	@$(CC) $(CFLAGS) -c $< -o $@

clean :
	@echo "$(RED)*******CLEAN********$(RESET)"
	@[ -e $(MLX)/libmlx.a ] && make clean -C $(MLX) && echo "$(GREEN)Clean-up done for $(CYAN)mlx$(GREEN)!$(RESET)" || echo "$(GREEN)No $(CYAN)mlx$(GREEN) object files present!$(RESET)"
	@make clean -C $(FTPRINTF)
	@[ -e $(SRC)/main.o ] && $(RM) $(SRC)/*o && echo "$(GREEN)Clean-up done for $(CYAN)fractol$(GREEN)!$(RESET)" || echo "$(GREEN)No $(CYAN)fractol$(GREEN) object files present!$(RESET)"

fclean : clean
	@echo "$(RED)*******FULL CLEAN********$(RESET)"
	@make fclean -C $(FTPRINTF)
	@[ -e $(MLX)/libmlx.a ] && make clean -C $(MLX) && echo "$(GREEN)Clean-up done for $(CYAN)mlx$(GREEN)!$(RESET)" || echo "$(GREEN)Nothing to clean-up with $(CYAN)mlx$(GREEN)!$(RESET)"
	@[ -e $(NAME) ] && $(RM) $(NAME) && echo "$(GREEN)Clean-up done for $(CYAN)fractol$(GREEN)!$(RESET)" || echo "$(GREEN)Nothing to clean-up with $(CYAN)fractol$(GREEN)!$(RESET)"
	@[ ! -e $(LPFLAGS) ] || rm $(LPFLAGS)  

re : fclean all
	@echo "$(YELLOW)*******RE********$(RESET)"

.PHONY:	all re clean fclean
