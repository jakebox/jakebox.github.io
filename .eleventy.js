module.exports = function(eleventyConfig) {

  // Copy any assets
  eleventyConfig.addPassthroughCopy({"./_assets": "assets"});

  eleventyConfig.addCollection("pages", function(collectionApi) {
    return collectionApi.getFilteredByGlob("pages/*").reverse();
  });
  
  eleventyConfig.addCollection("posts", function(collectionApi) {
    return collectionApi.getFilteredByGlob("posts/*.md").reverse();
  });
  
  // Add date filter for formatting dates
  eleventyConfig.addFilter("dateFormat", function(date) {
    return new Date(date).toLocaleDateString("en-US", {
      year: "numeric",
      month: "long", 
      day: "numeric"
    });
  });
  
  // Add excerpt filter
  eleventyConfig.addFilter("excerpt", function(content) {
    const excerpt = content.split('\n').slice(0, 3).join(' ');
    return excerpt.length > 150 ? excerpt.substring(0, 150) + '...' : excerpt;
  });

  eleventyConfig.addGlobalData("site", {
    title: "Jacob Boxerman's Blog"
  });

  eleventyConfig.addShortcode("image", function(src, alt, className = "") {
    return `<img src="${src}" alt="${alt}" class="${className}" loading="lazy">`;
  });

  return {
    dir: {
      input: ".",
      includes: "_includes",
    },
    markdownTemplateEngine: "njk",
    htmlTemplateEngine: "njk",
    templateFormats: ["md", "njk", "html"]
  };
};
