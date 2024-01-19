% MOVIES-INIT(1) movies 0.1
% Mehrshad Khansarian
% 2582-10-22

# NAME
movies-init - Initialize a movies repository

# SYNOPSIS
_movies_ _init_ [-n | \-\-name \<show-name\>] [-u | \-\-url \<url\>]

# DESCRIPTION
This command creates a movies repository - basically a directory named .movies with a text file named .info which includes the information given to the command. Subsequent commands may add more files to the directory.  

# OPTIONS
-n, \-\-name \<show-name\>  
&nbsp; &nbsp; Set the name of the show that is the prefix of all file names.  

-u, \-\-url \<url\>   
&nbsp; &nbsp; Set the download link of the first episode of the show.

# BUGS

See GitHub Issues: <https://github.com/mehrshad-kh/movies/issues>

# AUTHOR

Mehrshad Khansarian

# SEE ALSO

**movies**(1), **movies-continue**(1), **movies-download**(1), **movies-link**(1), **movies-play**(1) 
