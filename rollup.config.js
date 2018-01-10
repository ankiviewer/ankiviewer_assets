const av_web_static_dir = process.env.AV_WEB_STATIC_DIR

export default [
  'app', 'home', 'rules', 'search', 'settings'
].map((file) => {
  return {
    input: `js/${file}.js`,
    output: {
      file: `${av_web_static_dir}/js/${file}.js`,
      format: 'cjs',
      sourcemap: true
    }
  };
});
