# Installation and Quickstart
0. I've used ruby version 3.3.1 (see [.ruby-version](https://github.com/KarlHeitmann/code-challenge/blob/karl/.ruby-version) file), but any ruby > 3.0 should work. Just change the ruby version in that file to match yours.
1. Checkout this branch on your local machine.
2. Install dependencies
```
bundle install
```
3. Run `main.rb` with the html filename passed as first argument. Example:
```
bundle exec ruby main.rb files/van-gogh-paintings.html 
# or
bundle exec ruby main.rb spec/fixtures/leonardo-da-vinci-paintings.html 
```
**NOTE:** Both Van Gogh and Da Vinci HTML exists in my local branch. I've made two other searches: [pablo picasso paintings](https://www.google.com/search?q=pablo+picasso+paintings&sca_esv=77e9856747e8aa3f&sca_upv=1&sxsrf=ADLYWIJfOULzPuSWTZzzZbeL8_Mms1hIDw%3A1724007232476&source=hp&ei=QEPCZtXBGo7J1sQP0vG22Q8&iflsig=AL9hbdgAAAAAZsJRULswXzOwmvdnodegAK3vRBZuI6C6&ved=0ahUKEwjV4be1m_-HAxWOpJUCHdK4LfsQ4dUDCBY&uact=5&oq=pablo+picasso+paintings&gs_lp=Egdnd3Mtd2l6IhdwYWJsbyBwaWNhc3NvIHBhaW50aW5nczIKEAAYgAQYRhj7ATIFEAAYgAQyBRAAGIAEMgUQABiABDIFEAAYgAQyBRAAGIAEMgUQABiABDIFEAAYgAQyBRAAGIAEMgUQABiABEjkIVAAWI0gcAB4AJABAJgBvwmgAZgjqgEOMTYuMy4xLjUtMS4xLjG4AQPIAQD4AQGYAhegAoEkwgIKEAAYgAQYQxiKBcICChAuGIAEGEMYigXCAgUQLhiABMICCxAuGIAEGNEDGMcBwgILEC4YgAQYxwEYrwHCAg8QABiABBhDGIoFGEYY-wGYAwCSBxAxNi4zLjEuMC4xLjAuMS4xoAeMiAI&sclient=gws-wiz) & [salvador dali paintings](https://www.google.com/search?q=salvador+dali+paintings&sca_esv=77e9856747e8aa3f&sca_upv=1&sxsrf=ADLYWIL4sb9Augz0izimFaHKHppzDcFYMQ%3A1724007214473&source=hp&ei=LkPCZvzgGpTP1sQPx_GwAQ&iflsig=AL9hbdgAAAAAZsJRPoI75iIf2PfnhoFSSXOh2r67O3iO&ved=0ahUKEwj8r-2sm_-HAxWUp5UCHcc4LAAQ4dUDCBY&uact=5&oq=salvador+dali+paintings&gs_lp=Egdnd3Mtd2l6IhdzYWx2YWRvciBkYWxpIHBhaW50aW5nczIPEAAYgAQYQxiKBRhGGPsBMgoQABiABBhDGIoFMgUQABiABDIFEAAYgAQyBRAAGIAEMgUQABiABDIFEAAYgAQyBRAAGIAEMgUQABiABDIFEAAYgARI3h9QAFiGHnAAeACQAQCYAWagAfsLqgEEMjIuMbgBA8gBAPgBAZgCF6AC1AzCAgoQLhiABBhDGIoFwgILEC4YgAQY0QMYxwHCAgUQLhiABMICEBAuGIAEGNEDGEMYxwEYigXCAg4QLhiABBjHARiOBRivAcICCxAuGIAEGMcBGK8BmAMAkgcEMjEuMqAH_IEC&sclient=gws-wiz)  and both searches work. 

4. Run the tests
```
bundle exec rspec spec
```

# NOTES:

- In order to reduce noise on this PR, I kept changes to original files to the minimum. I gitignored my `Gemfile.lock` and `Gemfile-custom` (check out my [Gemfile-custom hook mechanism](https://github.com/KarlHeitmann/code-challenge/blob/4c46792d3747433a1a70bf0b5feced8a47574d62/Gemfile#L10), that's pretty cool), and fixed the [files/expected-array.json](https://github.com/serpapi/code-challenge/pull/277/commits/775d5419ce46bc4c778594edfa3fb990ea2908fd) by adding the missing curly braces, otherwise `JSON.parse` would have complained and raised an exception. I would like to move the fixtures you provided in the master branch to my `spec/fixtures` folder but I didn't do it to keep this PR noise to the minimum.
- strategy: top-down approach. I always like to solve the [big or most difficult problem first](https://github.com/serpapi/code-challenge/pull/277/commits/8e1c882c4645e0590186c47cbe440c1f6eda8df9), then [attack the smaller problems](https://github.com/serpapi/code-challenge/pull/277/commits/cc4b1f79f253ceccc30460fbb61ad95d08dffa10) and finish by doing a [code refactor](https://github.com/serpapi/code-challenge/pull/277/commits/4c46792d3747433a1a70bf0b5feced8a47574d62). On this branch, I made [atomic commits](https://www.aleksandrhovhannisyan.com/blog/atomic-git-commits/) and followed [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/). Every commit with new application code changes contains its corresponding tests.
- rubocop: I have my own opinions about some rubocop rules, and [some of them are controversial](https://github.com/KarlHeitmann/code-challenge/blob/4c46792d3747433a1a70bf0b5feced8a47574d62/.rubocop.yml#L6). I used them because it is my personal solution and wanted to show you my opinions. I'm not a guy with strong opinions, but I like to express them.

# Self-criticism / TODO

- Using [van-gogh-paintings.html](https://github.com/KarlHeitmann/code-challenge/blob/karl/files/van-gogh-paintings.html), it was not so clear how to determine which one is the right `<g-scrolling-carousel>` carousel (because there were 2 of these tags), I choosed [the one with the right attributes](https://github.com/KarlHeitmann/code-challenge/blob/4c46792d3747433a1a70bf0b5feced8a47574d62/lib/image_parser.rb#L43). But it could have been other criteria.

- I have a [loop](https://github.com/KarlHeitmann/code-challenge/blob/4c46792d3747433a1a70bf0b5feced8a47574d62/lib/image_parser.rb#L17) that looks very weird, and [it flattens](https://github.com/KarlHeitmann/code-challenge/blob/4c46792d3747433a1a70bf0b5feced8a47574d62/lib/image_parser.rb#L24) the results at the end of the method. Maybe I'll improve it in the next days, if I have the time and inspiration...

- Code coverage: I was lazy to set-up [simplecov](https://github.com/simplecov-ruby/simplecov) (yea... it should be a couple of lines), but at the beginning it was fairly easy to see the methods that needed to be tested. Now that I've added the [base abstract class](https://github.com/KarlHeitmann/code-challenge/blob/karl/lib/base_thumbnail_scraper.rb) I will set-up simplecov and add more tests.


# Extract Van Gogh Paintings Code Challenge

Goal is to extract a list of Van Gogh paintings from the attached Google search results page.

![Van Gogh paintings](https://github.com/serpapi/code-challenge/blob/master/files/van-gogh-paintings.png?raw=true "Van Gogh paintings")

## Instructions

This is already fully supported on SerpApi. ([relevant test], [html file], [sample json], and [expected array].)
Try to come up with your own solution and your own test.
Extract the painting `name`, `extensions` array (date), and Google `link` in an array.

Fork this repository and make a PR when ready.

Programming language wise, Ruby (with RSpec tests) is strongly suggested but feel free to use whatever you feel like.

Parse directly the HTML result page ([html file]) in this repository. No extra HTTP requests should be needed for anything.

[relevant test]: https://github.com/serpapi/test-knowledge-graph-desktop/blob/master/spec/knowledge_graph_claude_monet_paintings_spec.rb
[sample json]: https://raw.githubusercontent.com/serpapi/code-challenge/master/files/van-gogh-paintings.json
[html file]: https://raw.githubusercontent.com/serpapi/code-challenge/master/files/van-gogh-paintings.html
[expected array]: https://raw.githubusercontent.com/serpapi/code-challenge/master/files/expected-array.json

Add also to your array the painting thumbnails present in the result page file (not the ones where extra requests are needed). 

Test against 2 other similar result pages to make sure it works against different layouts. (Pages that contain the same kind of carrousel. Don't necessarily have to be paintings.)

The suggested time for this challenge is 4 hours. But, you can take your time and work more on it if you want.
