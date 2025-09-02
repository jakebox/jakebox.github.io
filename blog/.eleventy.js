module.exports = function(eleventyConfig) {
  // Copy CSS files to output
  eleventyConfig.addPassthroughCopy("css");

  // Copy original CSS from two directories up
  eleventyConfig.addPassthroughCopy({"../style.css": "css/style.css"});
  
  // Copy any assets
  eleventyConfig.addPassthroughCopy("assets");
  
  // Add a collection for blog posts
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
    title: "Jacob Boxerman"
  });

  return {
    dir: {
      input: ".",
      includes: "_includes",
      output: "_site"
    },
    markdownTemplateEngine: "njk",
    htmlTemplateEngine: "njk",
    templateFormats: ["md", "njk", "html"]
  };
};
