library(testit)

assert('file_ext() and sans_ext() work', {
  p = c('abc.doc', 'def123.tex#', 'path/to/foo.Rmd', 'backup.ppt~', 'pkg.tar.xz')
  (file_ext(p) %==% c('doc', 'tex#', 'Rmd', 'ppt~', 'tar.xz'))
  (sans_ext(p) %==% c('abc', 'def123', 'path/to/foo', 'backup', 'pkg'))
  (file_ext(c('foo.bar.gz', 'foo', 'file.nb.html')) %==% c('gz', '', 'nb.html'))
})

assert('with_ext() works for corner cases', {
  (with_ext(character(), 'abc') %==% character())
  (with_ext('abc', character()) %==% 'abc')
  (with_ext(NA_character_, 'abc') %==% NA_character_)
  (has_error(with_ext('abc', NA_character_)))
  (with_ext('abc', c('d', 'e')) %==% c('abc.d', 'abc.e'))
  (has_error(with_ext(c('a', 'b'), c('d', 'e', 'f'))))
  (with_ext(c('a', 'b'), c('d', 'e')) %==% c('a.d', 'b.e'))
  (with_ext(c('a', 'b'), c('d')) %==% c('a.d', 'b.d'))
  (with_ext(c('a', 'b', 'c'), c('', '.d', 'e.e')) %==% c('a', 'b.d', 'c.e.e'))
})

assert('same_path() works', {
  (is.na(same_path('~/foo', NA_character_)))
  (is.na(same_path(NA_character_, '~/foo')))
  (same_path('~/foo', file.path(Sys.getenv('HOME'), 'foo')))
  (!same_path(tempdir(), 'foo'))
})

assert('url_filename() returns the file names in URLs', {
  (url_filename('https://yihui.org/images/logo.png') %==% 'logo.png')
  (url_filename(c(
    'https://yihui.org/index.html',
    'https://yihui.org/index.html?foo=bar',
    'https://yihui.org/index.html#about'
  )) %==% rep('index.html', 3))
})

assert('is_abs_path() recognizes absolute paths on Windows and *nix', {
  (!is_abs_path('abc/def'))
  (is_abs_path(if (.Platform$OS.type == 'windows') {
    c('D:\\abc', '\\\\netdrive\\somewhere')
  } else '/abc/def'))
})

assert('del_empty_dir() correctly deletes empty dirs', {
  # do nothing is NULL
  (del_empty_dir(NULL) %==% NULL)
  # remove if empty
  dir.create(temp_dir <- tempfile())
  del_empty_dir(temp_dir)
  (!dir_exists(temp_dir))
  # do not remove if not empty
  dir.create(temp_dir <- tempfile())
  writeLines('test', tempfile(tmpdir = temp_dir))
  (del_empty_dir(temp_dir) %==% NULL)
  (dir_exists(temp_dir))
  unlink(temp_dir, recursive = TRUE)
})

