--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Maybe
import           Data.Monoid (mappend)
import           Hakyll
--------------------------------------------------------------------------------

config :: Configuration
config = defaultConfiguration
  { destinationDirectory = "docs"
  }

main :: IO ()
main = hakyllWith config $ do
    match "assets/images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "assets/*.js" $ do
        route   idRoute
        compile copyFileCompiler

    match "assets/*.css" $ do
        route   idRoute
        compile compressCssCompiler

    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= saveSnapshot "content"
            >>= return . fmap demoteHeaders
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    match "pages/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= saveSnapshot "content"
            >>= return . fmap demoteHeaders
            >>= loadAndApplyTemplate "templates/page.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAllSnapshots "posts/*" "content"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Archives"            `mappend`
                    myDefaultContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls

    create ["sitemap.xml"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            pages <- loadAll "pages/*"
            let sitemapCtx =
                  listField "entries" (pageCtx `mappend` (constField "baseUrl" "https://jakebox.github.io"))
                  (return (pages ++ posts)) `mappend`
                  myDefaultContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/sitemap.xml" sitemapCtx
                >>= relativizeUrls

    match "sidebar.org" $ do
      compile $ do
        pages <- loadAllSnapshots "pages/*" "content"
        let thisCtx =
              listField "pages" pageCtx (return pages)
        pandocCompiler
          >>= applyAsTemplate thisCtx
          >>= saveSnapshot "content"
          >>= relativizeUrls

    match "index.org" $ do
        route $ setExtension "html"
        compile $ do
          posts <- fmap (take 3) . recentFirst =<< loadAllSnapshots "posts/*" "content"
          let indexCtx =
                  listField "posts" postCtx (return posts)
          pandocCompiler
            >>= applyAsTemplate indexCtx
            >>= return . fmap demoteHeaders
            >>= loadAndApplyTemplate "templates/default.html" (myDefaultContext <> indexCtx)
            >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    myDefaultContext

sidebarCtx :: Context String
sidebarCtx =
  field "sidebar" $ \_ -> do
    body <- loadSnapshotBody "sidebar.org" "content"
    return body

pageCtx :: Context String
pageCtx =
    urlField "url" `mappend`
    titleField "title" `mappend`
    defaultContext

myDefaultContext :: Context String
myDefaultContext =
  sidebarCtx <> defaultContext
