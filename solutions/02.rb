def new_head(snake, direction)
  head_first_coordinate = snake[-1][0] + direction[0]
  head_second_coordinate = snake[-1][1] + direction[1]

  [head_first_coordinate, head_second_coordinate]
end

def play_field(dimensions)
  x_axis = [*0...dimensions[:width]]
  y_axis = [*0...dimensions[:height]]

  x_axis.product(y_axis)
end

def move(snake, direction)
  head = new_head(snake, direction)

  snake.dup.drop(1).push(head)
end

def grow(snake, direction)
  head = new_head(snake, direction)

  snake.dup.push(head)
end

def new_food(food, snake, dimensions)
  occupied = food + snake

  (play_field(dimensions) - occupied).sample
end

def obstacle_ahead?(snake, direction, dimensions)
  head = new_head(snake, direction)

  snake.include?(head) or not (play_field(dimensions).include?(head))
end

def danger?(snake, direction, dimensions)
  first_move = obstacle_ahead?(snake, direction, dimensions)

  snake_moved = move(snake, direction)
  second_move = obstacle_ahead?(snake_moved, direction, dimensions)

  first_move or second_move
end