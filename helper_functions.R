

# Turns a list of files into one 'large' matrix of data
make_expr_matrix <- function(file_list, markers){
  big_expr <- matrix(nrow = 0, ncol = length(markers))
  for (file in file_list){
    data <- read.FCS(file, transformation = FALSE, truncate_max_range = FALSE)
    all_cols <- colnames(data)
    expr <- data@exprs
    nums <- unlist(lapply(markers, function(x) grep(x, all_cols, ignore.case = TRUE)))
    big_expr <- rbind(big_expr, expr[, nums])
  }
  big_expr <- asinh(big_expr/5)
  big_expr
}
