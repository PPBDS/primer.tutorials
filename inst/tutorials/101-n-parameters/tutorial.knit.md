---
title: N Parameters
author: David Kane and Mihir Kaushal
tutorial:
  id: n-parameters
output:
  learnr::tutorial:
    progressive: yes
    'allow_skip:': yes
runtime: shiny_prerendered
description: 'Chapter 10 Tutorial: N Parameters'
---




<script>

function transfer_code(elem){
  Shiny.setInputValue("js_to_server", elem.previousElementSibling.dataset.label);
  
}

Shiny.addCustomMessageHandler('set-exercise-code', function(x) {
  var el = $(`.tutorial-exercise[data-label="${x.label}"] .tutorial-exercise-code-editor`)
  var editor = ace.edit($(el).attr('id'));
  editor.getSession().setValue(x.code);
  Shiny.setInputValue("js_to_server", null);
})
</script>




## Information
###


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="name" class="tutorial-question panel-body">
<div id="name-answer_container" class="shiny-html-output"></div>
<div id="name-message_container" class="shiny-html-output"></div>
<div id="name-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="email" class="tutorial-question panel-body">
<div id="email-answer_container" class="shiny-html-output"></div>
<div id="email-message_container" class="shiny-html-output"></div>
<div id="email-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="ID" class="tutorial-question panel-body">
<div id="ID-answer_container" class="shiny-html-output"></div>
<div id="ID-message_container" class="shiny-html-output"></div>
<div id="ID-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

<!-- Instructions to Users of this Template: -->

<!-- This is the template tutorial for creating any tutorial which uses the Cardinal Virtues to answer a question given a data set. Although its primary use is for the main chapters in the Primer, it could be used for independent tutorials as well. The letters `XX` are used to indicate locations which require editing. Comments with instructions are interspersed. Read https://ppbds.github.io/primer/cardinal-virtues.html for details on the Cardinal Virtues. -->

<!-- The tutorial is not done until you deal with, and remove, every XX. In general, XX will either mark a comment, which you should delete entirely once you have read it, or it will mark an object which you need to replace with the name that you have chosen. -->

<!-- How much hand-holding you do depends on tutorial number. For tutorial 4, we would want to provide the same sort of questions and verbiage as we see in Project #2 in the RStudio and Github tutorial. For tutorial 10, we can go much more quickly. -->

<!-- Note that the questions are a mixture of our three types: code, written (with answer) and written (without answer). The last is only (?) used for questions in which we ask the student to run a command like `show_file()`. Otherwise, we always provide an excellent written answer because students will generally look closely at our answer because they are concerned about whether or not their written answer matches ours. -->

<!-- Whenever you tell a student to make a change in the QMD, you should tell them to `Command/Ctrl + Shift + K` in order to render the document. This will also cause it to be saved. This is good practice for catching bugs early. (Professionals do this.) Then, the last step in these exercises is often some version of show_file() and then CP/CR. -->

<!-- Make use of, e.g., `show_file("tutorial-6.qmd", start = -5)` to get just the last 5 lines of the QMD. We don't want students to copy/paste the whole document. We also don't need to ensure that we get whatever it is that was just changed. We never look! Instead, we are just plausibly threatening to look.  -->

<!-- There are many opportunities for knowledge drops, especially after definition questions. Use them! Point out something about the details of the particular problem from the chapter. Recall that students generally won't read the chapter, so we need to pull out the highlights. -->

<!-- Most of the questions in the Temperance section relate to constructing a graphic. This leads lots of opportunities for knowledge drops. This is a good place to mention items from Courage which you might not have had room for in that section. -->

<!-- Make sure to uncomment the test code chunks once you have created the necessary objects. -->

<!-- Always create any modeling objects and then save them in data/ by hand. Then, when building the tutorial, just read in the object. See the below example. This is also discussed in Instructions for Writing Tutorials.

Note that the commented code is run once, by hand, but saved so that it could be modified in the future. The fit_gauss assignment is run every time one hits Run Tutorial. But it is fast, so there is no cost. -->

<!-- #fit_gauss <- brm(formula = att_end ~ treatment, -->
<!-- #             data = trains, -->
<!-- #             family = gaussian(), -->
<!-- #             silent = 2, -->
<!-- #             refresh = 0, -->
<!-- #             seed = 9) -->
<!-- #write_rds(fit_gauss, "data/fit_gauss.rds") -->

<!-- fit_gauss <- read_rds("data/fit_gauss.rds") -->

<!-- Future improvements to make in this document:

Turn it into a vignette at some point? 

In the same way that we give several quotes to choose from at the start of each section, we ought to give several different knowledge drops to choose from, in order of sophistication, for many of the standard questions, especially related to things like families and link functions. No need for authors to reinvent the wheel. 

Would be nice if part of the testing would run all the object creation code so that we can be sure all that code works. But that would have to be during testing only. We don't want that code to execute during Run Tutorial because it often takes too long.
-->

## Introduction
### 

This tutorial covers [Chapter 10: N Parameters](https://ppbds.github.io/primer/n-parameters.html) of [*Preceptor’s Primer for Bayesian Data Science: Using the Cardinal Virtues for Inference*](https://ppbds.github.io/primer/) by [David Kane](https://davidkane.info/). 

In this tutorial, we will consider models with many parameters and the complexities that arise therefrom.

As our models grow in complexity, we need to pay extra attention to basic assumptions like validity, stability, representativeness, and unconfoundedness. It is easy to jump right in and start interpreting. It is harder, but necessary, to ensure that our models are really answering our questions.

## Wisdom
### 

*All we can know is that we know nothing. And that’s the height of human wisdom.* - Leo Tolstoy

Imagine you are a Republican running for Governor in Texas. You need to allocate your campaign spending intelligently. For example, you want to do a better job of getting your voters to vote.

### 

For this tutorial, our general question is: 

> *How can campaigns influence voters?*

<!-- DK: How many people will do this? Zero! -->

We will be looking at the shaming tibble from the [**primer.data**](https://ppbds.github.io/primer.data/) package, sourced from “[Social Pressure and Voter Turnout: Evidence from a Large-Scale Field Experiment](https://doi.org/10.1017/S000305540808009X)” by Gerber, Green, and Larimer (2008).

We now need to translate our general question into a more precise question, one that we can answer with data:

> *What is the causal effect of postcards on casting a vote?*

### Exercise 1

Familiarize yourself with the data by loading **primer.data** at the Console and then typing `?shaming`. 

Find the year which this experiment took place and how many people were in the experiment. Write your answers below. 


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="wisdom-1" class="tutorial-question panel-body">
<div id="wisdom-1-answer_container" class="shiny-html-output"></div>
<div id="wisdom-1-message_container" class="shiny-html-output"></div>
<div id="wisdom-1-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

The data is from a study which aimed to find out whether and to what extent people are motivated to vote by social pressure.

### Exercise 2

In your own words, describe the key components of Wisdom when working on a data science problem.


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="wisdom-2" class="tutorial-question panel-body">
<div id="wisdom-2-answer_container" class="shiny-html-output"></div>
<div id="wisdom-2-message_container" class="shiny-html-output"></div>
<div id="wisdom-2-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

The authors conducted a field experiment to answer their questions about the extent people are motivated to vote by social pressure. Households were randomly assigned to either a control group or one of four treatment groups.

### Exercise 3

Define a Preceptor Table.


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="wisdom-3" class="tutorial-question panel-body">
<div id="wisdom-3-answer_container" class="shiny-html-output"></div>
<div id="wisdom-3-message_container" class="shiny-html-output"></div>
<div id="wisdom-3-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

The more experience you get as a data scientist, the more that you will come to understand that the Four Cardinal Virtues are not a one-way path. Instead, we circle round and round. Our initial question, instead of being fixed forever, is modified as we learn more about the data, and as we experiment with different modeling approaches.

### Exercise 4

Describe the key components of Preceptor Tables in general, without worrying about this specific problem. Use words like "units," "outcomes," and "covariates."


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="wisdom-4" class="tutorial-question panel-body">
<div id="wisdom-4-answer_container" class="shiny-html-output"></div>
<div id="wisdom-4-message_container" class="shiny-html-output"></div>
<div id="wisdom-4-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

This problem is causal so one of the covariates is a treatment. In our problem, the treatment is the type of postcard that the people get. 

### Exercise 5

Create a Github repo called `n-parameters`. Make sure to click the "Add a README file" check box. 

Connect the `n-parameters` Github repo to an R project on your computer. Name the R project `n-parameters` also. 

Select `File -> New File -> Quarto Document ...`. Provide a title (`"N Parameters"`) and an author (you). Save the document as `causal_effect.qmd`. 

Edit the `.gitignore` by adding `*Rproj`. Save and commit this in the Git tab. Push the commit.

In the Console, run:

```
show_file(".gitignore")
```

CP/CR.


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="wisdom-5" class="tutorial-question panel-body">
<div id="wisdom-5-answer_container" class="shiny-html-output"></div>
<div id="wisdom-5-message_container" class="shiny-html-output"></div>
<div id="wisdom-5-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

Remove everything below the YAML header from `analysis.qmd` and render the file. `Command/Ctrl + Shift + K` renders the file, this automatically saves the file as well.

### Exercise 6

What are the units for this problem?


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="wisdom-6" class="tutorial-question panel-body">
<div id="wisdom-6-answer_container" class="shiny-html-output"></div>
<div id="wisdom-6-message_container" class="shiny-html-output"></div>
<div id="wisdom-6-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

<!-- XX: A good knowledge drop for this exercise might involve other units which might be useful for related questions. For example, if the units for an presidential election are individual voters than, with a slightly different question, the units might be the 50 states. We want to show them the interplay between the exact question and which units define the Preceptor Table. -->

### Exercise 7

What is/are the outcome/outcomes for this problem?


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="wisdom-7" class="tutorial-question panel-body">
<div id="wisdom-7-answer_container" class="shiny-html-output"></div>
<div id="wisdom-7-message_container" class="shiny-html-output"></div>
<div id="wisdom-7-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

The outcomes in a Preceptor Table refer to a moment in time. In this case, the outcome occurs on Election Day in 2026. The covariates and treatments must be measured before the outcome, otherwise they can’t be modeled as connected with the outcome.

### Exercise 8

What are some covariates which you think might be useful for this problem, regardless of whether or not they might be included in the data?


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="wisdom-8" class="tutorial-question panel-body">
<div id="wisdom-8-answer_container" class="shiny-html-output"></div>
<div id="wisdom-8-message_container" class="shiny-html-output"></div>
<div id="wisdom-8-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

There may be other covariates as well. We can’t get too detailed until we look at the data.

### Exercise 9

What are the treatments, if any, for this problem?


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="wisdom-9" class="tutorial-question panel-body">
<div id="wisdom-9-answer_container" class="shiny-html-output"></div>
<div id="wisdom-9-message_container" class="shiny-html-output"></div>
<div id="wisdom-9-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

<!-- XX: Again, we dialogue. Any question, or broad topic, will use words. And words are not precise! Lots of possible treatments, each different from the other, are close to the original words. Drop some knowledge, or even speculation, about what sorts of treatments might be relevant in similar problems.  -->

There are many types of political campaign strategies used to try to increase the voter engagement. Our question is focusing on postcards. But if we were concerned with the effect of website advertisement, then our treatments would be the types of advertisement.  
### Exercise 10

What moment in time does the Preceptor Table refer to? It might be helpful to refer to the [N Parameters chapter](https://ppbds.github.io/primer/n-parameters.html).


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="wisdom-10" class="tutorial-question panel-body">
<div id="wisdom-10-answer_container" class="shiny-html-output"></div>
<div id="wisdom-10-message_container" class="shiny-html-output"></div>
<div id="wisdom-10-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

The moment in time is usually found in the question we are trying to answer. 

We can include the time in our question:

> *What is the causal effect of postcards on voting in the 2026 Texas election?*

### Exercise 11

Define causal effect.


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="wisdom-11" class="tutorial-question panel-body">
<div id="wisdom-11-answer_container" class="shiny-html-output"></div>
<div id="wisdom-11-message_container" class="shiny-html-output"></div>
<div id="wisdom-11-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

There will be at least two potential outcomes for every unit for a causal model. The causal effect, for each individual, is the difference in voting behavior under treatment versus control.

### Exercise 12

What is the fundamental problem of causal inference?


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="wisdom-12" class="tutorial-question panel-body">
<div id="wisdom-12-answer_container" class="shiny-html-output"></div>
<div id="wisdom-12-message_container" class="shiny-html-output"></div>
<div id="wisdom-12-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

<!-- XX: More discussion about potential outcomes in the current problem. Counter-factuals are hard to think about. Help students by providing discussion of the ones under consideration here. Are they plausible? What would make them more plausible? -->

If we observe that a person who got a postcard ended up voting, we can never know for sure that the postcard *caused* that person to vote as there could have been other factors that impact the voter engagement. This is why we need to be aware of any potential variables that may change the outcome. We have multiple people in the experiment which can make the data more accurate. 

### Exercise 13

How does the motto "No causal inference without manipulation." apply in this problem?


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="wisdom-13" class="tutorial-question panel-body">
<div id="wisdom-13-answer_container" class="shiny-html-output"></div>
<div id="wisdom-13-message_container" class="shiny-html-output"></div>
<div id="wisdom-13-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

<!-- XX: Can you really manipulate the treatments? In reality or in theory? How? What details would need to change to make this more or less plausible? -->

With any experiment, it is important to have a control group so there is a comparison that can be made. 

### Exercise 14

Describe in words the Preceptor Table for this problem.


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="wisdom-14" class="tutorial-question panel-body">
<div id="wisdom-14-answer_container" class="shiny-html-output"></div>
<div id="wisdom-14-message_container" class="shiny-html-output"></div>
<div id="wisdom-14-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

The Preceptor Table for this problem looks something like this:


```{=html}
<div id="pxrydypwoq" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#pxrydypwoq table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#pxrydypwoq thead, #pxrydypwoq tbody, #pxrydypwoq tfoot, #pxrydypwoq tr, #pxrydypwoq td, #pxrydypwoq th {
  border-style: none;
}

#pxrydypwoq p {
  margin: 0;
  padding: 0;
}

#pxrydypwoq .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#pxrydypwoq .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#pxrydypwoq .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#pxrydypwoq .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#pxrydypwoq .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#pxrydypwoq .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#pxrydypwoq .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#pxrydypwoq .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#pxrydypwoq .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#pxrydypwoq .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#pxrydypwoq .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#pxrydypwoq .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#pxrydypwoq .gt_spanner_row {
  border-bottom-style: hidden;
}

#pxrydypwoq .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#pxrydypwoq .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#pxrydypwoq .gt_from_md > :first-child {
  margin-top: 0;
}

#pxrydypwoq .gt_from_md > :last-child {
  margin-bottom: 0;
}

#pxrydypwoq .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#pxrydypwoq .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#pxrydypwoq .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#pxrydypwoq .gt_row_group_first td {
  border-top-width: 2px;
}

#pxrydypwoq .gt_row_group_first th {
  border-top-width: 2px;
}

#pxrydypwoq .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#pxrydypwoq .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#pxrydypwoq .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#pxrydypwoq .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#pxrydypwoq .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#pxrydypwoq .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#pxrydypwoq .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#pxrydypwoq .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#pxrydypwoq .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#pxrydypwoq .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#pxrydypwoq .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#pxrydypwoq .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#pxrydypwoq .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#pxrydypwoq .gt_left {
  text-align: left;
}

#pxrydypwoq .gt_center {
  text-align: center;
}

#pxrydypwoq .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#pxrydypwoq .gt_font_normal {
  font-weight: normal;
}

#pxrydypwoq .gt_font_bold {
  font-weight: bold;
}

#pxrydypwoq .gt_font_italic {
  font-style: italic;
}

#pxrydypwoq .gt_super {
  font-size: 65%;
}

#pxrydypwoq .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#pxrydypwoq .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#pxrydypwoq .gt_indent_1 {
  text-indent: 5px;
}

#pxrydypwoq .gt_indent_2 {
  text-indent: 10px;
}

#pxrydypwoq .gt_indent_3 {
  text-indent: 15px;
}

#pxrydypwoq .gt_indent_4 {
  text-indent: 20px;
}

#pxrydypwoq .gt_indent_5 {
  text-indent: 25px;
}

#pxrydypwoq .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}

#pxrydypwoq div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="5" class="gt_heading gt_title gt_font_normal gt_bottom_border" style>Preceptor Table</td>
    </tr>
    
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" style="font-size: large; text-align: left; vertical-align: middle;" scope="col" id="&lt;span class='gt_from_md'&gt;ID&lt;/span&gt;"><span class='gt_from_md'>ID</span></th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="Outcomes">
        <span class="gt_column_spanner">Outcomes</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="Covariates">
        <span class="gt_column_spanner">Covariates</span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;span class='gt_from_md'&gt;Voting After Control&lt;/span&gt;"><span class='gt_from_md'>Voting After Control</span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;span class='gt_from_md'&gt;Voting After Treatment&lt;/span&gt;"><span class='gt_from_md'>Voting After Treatment</span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;span class='gt_from_md'&gt;Treatment&lt;/span&gt;"><span class='gt_from_md'>Treatment</span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;span class='gt_from_md'&gt;Engagement&lt;/span&gt;"><span class='gt_from_md'>Engagement</span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="ID" class="gt_row gt_left" style="border-right-width: 1px; border-right-style: solid; border-right-color: #000000;"><span class='gt_from_md'>1</span></td>
<td headers="voting_after_control" class="gt_row gt_center"><span class='gt_from_md'>1</span></td>
<td headers="voting_after_treated" class="gt_row gt_center"><span class='gt_from_md'>1</span></td>
<td headers="treatment" class="gt_row gt_center"><span class='gt_from_md'>Yes</span></td>
<td headers="engagement" class="gt_row gt_center"><span class='gt_from_md'>1</span></td></tr>
    <tr><td headers="ID" class="gt_row gt_left" style="border-right-width: 1px; border-right-style: solid; border-right-color: #000000;"><span class='gt_from_md'>2</span></td>
<td headers="voting_after_control" class="gt_row gt_center"><span class='gt_from_md'>0</span></td>
<td headers="voting_after_treated" class="gt_row gt_center"><span class='gt_from_md'>1</span></td>
<td headers="treatment" class="gt_row gt_center"><span class='gt_from_md'>No</span></td>
<td headers="engagement" class="gt_row gt_center"><span class='gt_from_md'>3</span></td></tr>
    <tr><td headers="ID" class="gt_row gt_left" style="border-right-width: 1px; border-right-style: solid; border-right-color: #000000;"><span class='gt_from_md'>…</span></td>
<td headers="voting_after_control" class="gt_row gt_center"><span class='gt_from_md'>…</span></td>
<td headers="voting_after_treated" class="gt_row gt_center"><span class='gt_from_md'>…</span></td>
<td headers="treatment" class="gt_row gt_center"><span class='gt_from_md'>…</span></td>
<td headers="engagement" class="gt_row gt_center"><span class='gt_from_md'>…</span></td></tr>
    <tr><td headers="ID" class="gt_row gt_left" style="border-right-width: 1px; border-right-style: solid; border-right-color: #000000;"><span class='gt_from_md'>10</span></td>
<td headers="voting_after_control" class="gt_row gt_center"><span class='gt_from_md'>1</span></td>
<td headers="voting_after_treated" class="gt_row gt_center"><span class='gt_from_md'>1</span></td>
<td headers="treatment" class="gt_row gt_center"><span class='gt_from_md'>Yes</span></td>
<td headers="engagement" class="gt_row gt_center"><span class='gt_from_md'>6</span></td></tr>
    <tr><td headers="ID" class="gt_row gt_left" style="border-right-width: 1px; border-right-style: solid; border-right-color: #000000;"><span class='gt_from_md'>11</span></td>
<td headers="voting_after_control" class="gt_row gt_center"><span class='gt_from_md'>1</span></td>
<td headers="voting_after_treated" class="gt_row gt_center"><span class='gt_from_md'>0</span></td>
<td headers="treatment" class="gt_row gt_center"><span class='gt_from_md'>Yes</span></td>
<td headers="engagement" class="gt_row gt_center"><span class='gt_from_md'>2</span></td></tr>
    <tr><td headers="ID" class="gt_row gt_left" style="border-right-width: 1px; border-right-style: solid; border-right-color: #000000;"><span class='gt_from_md'>…</span></td>
<td headers="voting_after_control" class="gt_row gt_center"><span class='gt_from_md'>…</span></td>
<td headers="voting_after_treated" class="gt_row gt_center"><span class='gt_from_md'>…</span></td>
<td headers="treatment" class="gt_row gt_center"><span class='gt_from_md'>…</span></td>
<td headers="engagement" class="gt_row gt_center"><span class='gt_from_md'>…</span></td></tr>
    <tr><td headers="ID" class="gt_row gt_left" style="border-right-width: 1px; border-right-style: solid; border-right-color: #000000;"><span class='gt_from_md'>N</span></td>
<td headers="voting_after_control" class="gt_row gt_center"><span class='gt_from_md'>0</span></td>
<td headers="voting_after_treated" class="gt_row gt_center"><span class='gt_from_md'>1</span></td>
<td headers="treatment" class="gt_row gt_center"><span class='gt_from_md'>No</span></td>
<td headers="engagement" class="gt_row gt_center"><span class='gt_from_md'>2</span></td></tr>
  </tbody>
  
  
</table>
</div>
```

### Exercise 15

<!-- XX: It is a feature that this question almost forces students to go to the chapter and read about the data. This entire sentence will not be included in your summary at the end of Wisdom, but bits of it will be mentioned. -->

Write a couple sentences describing the data you have to answer your question. 

Running `?shaming` in the console after loading the **primer.data** package will help you answer this question. 


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="wisdom-15" class="tutorial-question panel-body">
<div id="wisdom-15-answer_container" class="shiny-html-output"></div>
<div id="wisdom-15-message_container" class="shiny-html-output"></div>
<div id="wisdom-15-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

<!-- XX. Insert a question or two which accomplishes the second chunk of QMD work. This begins with the creation of an `analysis.qmd` file (although you can use any name for it), its rendering to ensure that your computer setup is correct. The addition of *_files to the .gitignore so that we do not commit those junk files. It ends with a commit and push. show_file(".gitignore", start = -5) is not a bad last question. -->

We can update our question:

> *What is the causal effect of postcards on voting in the 2026 Texas gubernatorial election? Do those effects vary by political engagement?*

### Exercise 16

Load the **tidyverse** package.

<div class="tutorial-exercise" data-label="wisdom-16" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"><script type="application/json" data-ui-opts="1">{"engine":"r","has_checker":false,"caption":"<span data-i18n=\"text.enginecap\" data-i18n-opts=\"{&quot;engine&quot;:&quot;R&quot;}\">R Code<\/span>"}</script></div>

<div class="tutorial-exercise-support" data-label="wisdom-16-hint-1" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;">

``` text
library(...)
```

</div>



### 

<!-- XX: Insert comments about the data. This continues to be the primary type of knowledge drop. These comments can also be sophisticated, especially in the way that they connect the data to the Preceptor Table and to the population. -->

### Exercise 17

Load the **primer.data** package.

<div class="tutorial-exercise" data-label="wisdom-17" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"><script type="application/json" data-ui-opts="1">{"engine":"r","has_checker":false,"caption":"<span data-i18n=\"text.enginecap\" data-i18n-opts=\"{&quot;engine&quot;:&quot;R&quot;}\">R Code<\/span>"}</script></div>

<div class="tutorial-exercise-support" data-label="wisdom-17-hint-1" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;">

``` text
library(...)
```

</div>



### 

<!-- XX: Insert comments about the data. This continues to be the primary type of knowledge drop. These comments can also be sophisticated, especially in the way that they connect the data to the Preceptor Table and to the population. -->

### Exercise 18

Run `glimpse()` on `shaming`. 

<div class="tutorial-exercise" data-label="wisdom-18" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"><script type="application/json" data-ui-opts="1">{"engine":"r","has_checker":false,"caption":"<span data-i18n=\"text.enginecap\" data-i18n-opts=\"{&quot;engine&quot;:&quot;R&quot;}\">R Code<\/span>"}</script></div>

<div class="tutorial-exercise-support" data-label="wisdom-18-hint-1" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;">

``` text
glimpse(...)
```

</div>



### 

`glimpse()` gives us a look at the raw data contained within the `shaming` data set. At the very top of the output, we can see the number of rows and columns, or observations and variables, respectively. We see that there are 344,084 observations, with each row corresponding to a unique respondent.

### Exercise 19

Pipe `shaming` to `count()` with `treament` inside of it.

<div class="tutorial-exercise" data-label="wisdom-19" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"><script type="application/json" data-ui-opts="1">{"engine":"r","has_checker":false,"caption":"<span data-i18n=\"text.enginecap\" data-i18n-opts=\"{&quot;engine&quot;:&quot;R&quot;}\">R Code<\/span>"}</script></div>

<div class="tutorial-exercise-support" data-label="wisdom-19-hint-1" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;">

``` text
shaming |> count(...)
```

</div>



### 

Four types of treatments were used in the experiment, with voters receiving one of the four types of mailing. All of the mailing treatments carried the message, “DO YOUR CIVIC DUTY - VOTE!”.

### Exercise 20

Pipe `shaming` to the following:
         
```
mutate(p_00 = (primary_00 == "Yes"), p_02 = (primary_02 == "Yes"),
       p_04 = (primary_04 == "Yes"), g_00 = (general_00 == "Yes"),
       g_02 = (general_02 == "Yes"), g_04 = (general_04 == "Yes"),
civ_engage = p_00 + p_02 + p_04 + g_00 + g_02 + g_04,
voter_class = case_when(civ_engage %in% c(5, 6) ~ "Always Vote",
                        civ_engage %in% c(3, 4) ~ "Sometimes Vote",
                        civ_engage %in% c(1, 2) ~ "Rarely Vote"),
voter_class = factor(voter_class, levels = c("Rarely Vote", "Sometimes Vote", "Always Vote")), age_z = as.numeric(scale(age))) 
```

<div class="tutorial-exercise" data-label="wisdom-20" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"><script type="application/json" data-ui-opts="1">{"engine":"r","has_checker":false,"caption":"<span data-i18n=\"text.enginecap\" data-i18n-opts=\"{&quot;engine&quot;:&quot;R&quot;}\">R Code<\/span>"}</script></div>

<div class="tutorial-exercise-support" data-label="wisdom-20-hint-1" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;">

``` text
x <- shaming |> mutate(...)
```

</div>



### 

<!-- XX: Insert comments about the data. This continues to be the primary type of knowledge drop. These comments can also be sophisticated, especially in the way that they connect the data to the Preceptor Table and to the population. -->

### Exercise 21

Continue the pipe to `rename()` with `voted` being set to `primary_06`.
         
<div class="tutorial-exercise" data-label="wisdom-21" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"><script type="application/json" data-ui-opts="1">{"engine":"r","has_checker":false,"caption":"<span data-i18n=\"text.enginecap\" data-i18n-opts=\"{&quot;engine&quot;:&quot;R&quot;}\">R Code<\/span>"}</script></div>

<button onclick="transfer_code(this)">Copy previous code</button>

<div class="tutorial-exercise-support" data-label="wisdom-21-hint-1" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;">

``` text
... |> rename(voted = primary_06)
```

</div>



### 

<!-- XX: Insert comments about the data. This continues to be the primary type of knowledge drop. These comments can also be sophisticated, especially in the way that they connect the data to the Preceptor Table and to the population. -->

### Exercise 22

Continue the pipe to `select()` and choose `voted`, `treatment`, `sex`, `age_z`, `civ_engage`, and `voter_class`. Then finally finish this pipe with `drop_na()`.
         
<div class="tutorial-exercise" data-label="wisdom-22" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"><script type="application/json" data-ui-opts="1">{"engine":"r","has_checker":false,"caption":"<span data-i18n=\"text.enginecap\" data-i18n-opts=\"{&quot;engine&quot;:&quot;R&quot;}\">R Code<\/span>"}</script></div>

<button onclick="transfer_code(this)">Copy previous code</button>

<div class="tutorial-exercise-support" data-label="wisdom-22-hint-1" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;">

``` text
... |> select(voted, treatment, sex, age_z, civ_engage, voter_class) |> drop_na()
```

</div>



### 

Set all of this to an object `data`. When you run again, nothing should print out because the code is being set to an object.

### Exercise 23

Start a new pipe with `data` to `sample_frac()` with `0.5` as the parameter.
         
<div class="tutorial-exercise" data-label="wisdom-23" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"><script type="application/json" data-ui-opts="1">{"engine":"r","has_checker":false,"caption":"<span data-i18n=\"text.enginecap\" data-i18n-opts=\"{&quot;engine&quot;:&quot;R&quot;}\">R Code<\/span>"}</script></div>

<div class="tutorial-exercise-support" data-label="wisdom-23-hint-1" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;">

``` text
data |> sample_frac(...)
```

</div>



### 

<!-- XX -->

### Exercise 24

Continue the pipe to `ggpot()` with `x` set to `civ_engage` and `y` set to `voted` inside `aes()`. Also add `geom_jitter()` with `alpha` set to `0.03` and `height` set to `0.1`.
         
<div class="tutorial-exercise" data-label="wisdom-24" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"><script type="application/json" data-ui-opts="1">{"engine":"r","has_checker":false,"caption":"<span data-i18n=\"text.enginecap\" data-i18n-opts=\"{&quot;engine&quot;:&quot;R&quot;}\">R Code<\/span>"}</script></div>

<button onclick="transfer_code(this)">Copy previous code</button>

<div class="tutorial-exercise-support" data-label="wisdom-24-hint-1" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;">

``` text
... |> 
  ggplot(aes(...)) +
    geom_jitter(...)
```

</div>



### 

<!-- XX -->

### Exercise 25

Using the previous code, add `scale_x_continuous()` with `breaks` set to `1:6` and also add `scale_y_continuous()` with `breaks` set to `c(0, 1)` and `labels` set to `c("No", "Yes")`.
         
<div class="tutorial-exercise" data-label="wisdom-25" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"><script type="application/json" data-ui-opts="1">{"engine":"r","has_checker":false,"caption":"<span data-i18n=\"text.enginecap\" data-i18n-opts=\"{&quot;engine&quot;:&quot;R&quot;}\">R Code<\/span>"}</script></div>

<button onclick="transfer_code(this)">Copy previous code</button>

<div class="tutorial-exercise-support" data-label="wisdom-25-hint-1" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;">

``` text
... +
    scale_x_continuous(breaks = 1:6) + 
    scale_y_continuous(breaks = c(0, 1), labels = c("No", "Yes"))
```

</div>



### 

<!-- XX -->

### Exercise 26

Finally, using the previous code, add the `labs()` layer.
         
<div class="tutorial-exercise" data-label="wisdom-26" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"><script type="application/json" data-ui-opts="1">{"engine":"r","has_checker":false,"caption":"<span data-i18n=\"text.enginecap\" data-i18n-opts=\"{&quot;engine&quot;:&quot;R&quot;}\">R Code<\/span>"}</script></div>

<button onclick="transfer_code(this)">Copy previous code</button>

<div class="tutorial-exercise-support" data-label="wisdom-26-hint-1" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"></div>



### 

The graph should look like this:

<img src="tutorial_files/figure-html/unnamed-chunk-2-1.png" width="624" />

Although this plot is pleasing, we need to create an actual model with this data in order to answer our questions.

<!-- XX: It is now time for the third set of QMD edits. Add a new code chunk, the setup chunk, to the QMD. Copy/paste all the library commands to it. Render. Note all the ugliness. Add #| message: false. Add execute: echo: false to the YAML header. Add #| label: setup. Render again. Everything looks nice. Again, these could be several questions in the earlier tutorials or just one long question later. Ends with show_file("analysis.qmd", start = -5). This will be the most common ending question in QMD-editing exercises to come. -->

<!-- XX: Add code questions about EDA with your data. In particular, add at least one question about the dependent variable in the model along with one or more questions about covariates. If there is a treatment variable, you must include a question about it. -->

<!-- Variable questions come in two types. First there are questions which require the student to run, say, summary() on the variable. Then, knowledge about the variable can be dropped. Second, there are questions which ask for a one sentence summary about the variable, something which could be used in our summary of the project. For example: "Civility is measured on a 1 through 7 scale with higher values corresponding to greater civility." -->

<!-- XX: If necessary, provide code exercises which, line-by-line, create the pipeline which creates the cleaned data that will be used in modeling. For many tutorials, this is unnecessary since we can just use the raw tibble that is available in whatever package. But we sometimes need some code like

nes |> 
  filter(year == 1992) |> 
  drop_na()

We have three code exercises, each adding one line to the pipeline, explaining what we are doing and why. It is nice that, for each exercise, something is spat out.
-->

<!-- XX: If such a pipeline was built, there is one QMD question which requires that you add a new code chunk to the QMD, copy/paste the pipeline and assign the result to some object like `model_data` or whatever:

nes_92 <- nes |> 
  filter(year == 1992) |> 
  drop_na()

`Command/ctrl + Shift + K` follows, perhaps with a show_file("analysis.qmd", start = -5)
-->


### Exercise 27

In your own words, define "validity" as we use the term.


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="wisdom-27" class="tutorial-question panel-body">
<div id="wisdom-27-answer_container" class="shiny-html-output"></div>
<div id="wisdom-27-message_container" class="shiny-html-output"></div>
<div id="wisdom-27-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

In order to consider the two data sets to be drawn from the same population, the columns from one must have a valid correspondence with the columns in the other.

### Exercise 28

Provide one reason why the assumption of validity might not hold for this problem.

<!-- This is an important question, as are the similar questions for other assumptions! Spend some time making sure that your example answer is a good one. -->


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="wisdom-28" class="tutorial-question panel-body">
<div id="wisdom-28-answer_container" class="shiny-html-output"></div>
<div id="wisdom-28-message_container" class="shiny-html-output"></div>
<div id="wisdom-28-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

Fortunately, at least for our continued use of this example, we will assume that validity holds. The outcome variable in our data and in our Preceptor Table are close enough — even though one is for a primary election while the other is for a general election — that we can just stack them. At the back of our minds we should remember that the answer that we will find will be nowhere close to being 100% accurate. 

### Exercise 29

<!-- XX: In creating your own answer to questions like this, check with the chapter. One might already be provided! If not, it is often useful to revisit the relevant section of the Key Concepts chapter in the Primer. -->

<!-- Example: *Using data from a 2012 survey of Boston-area commuters, we seek to understand the relationship between income and political ideology in Chicago and similar cities in 2020. In particular, what percentage of individuals who make more than $100,000 per year are liberal?* -->

<!-- It is very difficult to craft a question which causes students to give a sentence that is good. Do your best. -->

Summarize the state of your work so far in one sentence. Make reference to the data you have and to the specific question you are trying to answer. 


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="wisdom-29" class="tutorial-question panel-body">
<div id="wisdom-29-answer_container" class="shiny-html-output"></div>
<div id="wisdom-29-message_container" class="shiny-html-output"></div>
<div id="wisdom-29-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

Edit you answer as you see fit, but do not copy/paste our answer exactly. Add this summary to `causal_effect.qmd`, `Command/Ctrl + Shift + K`, and then commit/push.

## Justice
### 

*It is in justice that the ordering of society is centered.* - Aristotle

### Exercise 1

In your own words, name the four key components of Justice for working on a data science problem.


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="justice-1" class="tutorial-question panel-body">
<div id="justice-1-answer_container" class="shiny-html-output"></div>
<div id="justice-1-message_container" class="shiny-html-output"></div>
<div id="justice-1-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

<!-- XX: All of Justice is about concerns that you have, reasons why the model you create might not work as well as you hope. Drop knowledge/discussion as you see fit, but the central theme is *worries*. Connect some of the specific data discussion from Wisdom to these assumptions. -->

### Exercise 2

In your own words, define a Population Table.


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="justice-2" class="tutorial-question panel-body">
<div id="justice-2-answer_container" class="shiny-html-output"></div>
<div id="justice-2-message_container" class="shiny-html-output"></div>
<div id="justice-2-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

### Exercise 3

In your own words, define the assumption of "stability" when employed in the context of data science.


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="justice-3" class="tutorial-question panel-body">
<div id="justice-3-answer_container" class="shiny-html-output"></div>
<div id="justice-3-message_container" class="shiny-html-output"></div>
<div id="justice-3-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

<!-- XX: You can keep just one of these two, if you like. Or delete both and add your own knowledge drop. -->

<!-- Stability is all about *time*. Is the relationship among the columns in the Population Table stable over time? In particular, is the relationship --- which is another way of saying "mathematical formula" --- at the time the data was gathered the same as the relationship at the (generally later) time references by the Preceptor Table. -->

<!-- *The longer the time period covered by the Preceptor Table (and the data), the more suspect the assumption of stability becomes.*  -->

### Exercise 4

Provide one reason why the assumption of stability might not be true in this case.


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="justice-4" class="tutorial-question panel-body">
<div id="justice-4-answer_container" class="shiny-html-output"></div>
<div id="justice-4-message_container" class="shiny-html-output"></div>
<div id="justice-4-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

### Exercise 5

In your own words, define the assumption of "representativeness" when employed in the context of data science.


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="justice-5" class="tutorial-question panel-body">
<div id="justice-5-answer_container" class="shiny-html-output"></div>
<div id="justice-5-message_container" class="shiny-html-output"></div>
<div id="justice-5-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

<!-- XX: Keep one of these. -->

<!-- Ideally, we would like both the Preceptor Table *and* our data to be random samples from the population. Sadly, this is almost never the case. -->

<!-- Stability looks across time periods. Reprentativeness looks within time periods. -->



### Exercise 6

Provide one reason why the assumption of representativeness might not be true in this case.


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="justice-6" class="tutorial-question panel-body">
<div id="justice-6-answer_container" class="shiny-html-output"></div>
<div id="justice-6-message_container" class="shiny-html-output"></div>
<div id="justice-6-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

### Exercise 7

In your own words, define the assumption of "unconfoundedness" when employed in the context of data science.


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="justice-7" class="tutorial-question panel-body">
<div id="justice-7-answer_container" class="shiny-html-output"></div>
<div id="justice-7-message_container" class="shiny-html-output"></div>
<div id="justice-7-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

<!-- XX: Keep one. -->

<!-- This assumption is only relevant for causal models. We describe a model as "confounded" if this is not true.  -->

<!-- The easiest way to ensure unconfoundedness is to assign treatment randomly. -->

### Exercise 8

<!-- XX: Delete this question for non-causal models. -->

Provide one reason why the assumption of unconfoundedness might not be true (or relevant) in this case.


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="justice-8" class="tutorial-question panel-body">
<div id="justice-8-answer_container" class="shiny-html-output"></div>
<div id="justice-8-message_container" class="shiny-html-output"></div>
<div id="justice-8-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

<!-- XX: Most of our simple examples use random assignment. So, if fact, confoundedness is not a concern. But this knowledge drop, and perhaps the couple before, should address this topic, by pondering what we would worry about if treatment assignment had not been random.  -->

### Exercise 9

Summarize the state of your work so far in two or three sentences. Make reference to the data you have and to the question you are trying to answer. Feel free to copy from your answer at the end of the Wisdom Section. Mention one specific problem which casts doubt on your approach. 



```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="justice-9" class="tutorial-question panel-body">
<div id="justice-9-answer_container" class="shiny-html-output"></div>
<div id="justice-9-message_container" class="shiny-html-output"></div>
<div id="justice-9-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

Edit the summary paragraph in `causal_effect.qmd` as you see fit, but do not copy/paste our answer exactly. `Command/Ctrl + Shift + K`, and then commit/push.


## Courage
### 

<!-- XX: Choose one. -->

*Courage is found in unlikely places.* - J.R.R. Tolkien
*Courage is being scared to death, but saddling up anyway.* - John Wayne
*Courage is going from failure to failure without losing enthusiasm.* - Winston Churchill
*Courage is the commitment to begin without any guarantee of success.* - Johann Wolfgang von Goethe


<!-- Questions about models, tests, and the DGM. -->


### Exercise 1

In your own words, describe the components of the virtue of Courage for analyzing data.


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="courage-1" class="tutorial-question panel-body">
<div id="courage-1-answer_container" class="shiny-html-output"></div>
<div id="courage-1-message_container" class="shiny-html-output"></div>
<div id="courage-1-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

### Exercise 2

Load the **brms** package.

<div class="tutorial-exercise" data-label="courage-2" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"><script type="application/json" data-ui-opts="1">{"engine":"r","has_checker":false,"caption":"<span data-i18n=\"text.enginecap\" data-i18n-opts=\"{&quot;engine&quot;:&quot;R&quot;}\">R Code<\/span>"}</script></div>

<div class="tutorial-exercise-support" data-label="courage-2-hint-1" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;">

``` text
library(...)
```

</div>



### 

<!-- XX: The Courage section of each chapter is the most complex because modeling is hard. Use opportunities for knowledge drops, like this one, judiciously. -->

### Exercise 3

Load the **tidybayes** package.

<div class="tutorial-exercise" data-label="courage-3" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"><script type="application/json" data-ui-opts="1">{"engine":"r","has_checker":false,"caption":"<span data-i18n=\"text.enginecap\" data-i18n-opts=\"{&quot;engine&quot;:&quot;R&quot;}\">R Code<\/span>"}</script></div>

<div class="tutorial-exercise-support" data-label="courage-3-hint-1" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;">

``` text
library(...)
```

</div>



### 

### Exercise 4

Add `library(brms)` and `library(tidybayes)` to `causal_effect.qmd`. `Command/Ctrl + Shift + K`. At the Console, run:

```
tutorial.helpers::show_file("causal_effect.qmd", pattern = "brms|tidybayes")
```

CP/CR.


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="courage-4" class="tutorial-question panel-body">
<div id="courage-4-answer_container" class="shiny-html-output"></div>
<div id="courage-4-message_container" class="shiny-html-output"></div>
<div id="courage-4-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

<!-- XX: For a knowledge drop, there is nothing wrong with discussion regular expressions, which is the magic which allows us to just pull out the two lines in the QMD which we want. But better would just be more Courage knowledge drops. -->


### Exercise 5

Create a model using `brm()` from the **brms** package. Your arguments should be XX. 

<!-- Search and replace "fit_postcard_vote" as appropriate. As a convention, the name of a fitted model object should always start with `fit_`. -->

<!-- Don't forget to create this model yourself in the setup chunk. Do this once, save the object, comment out that code and then just read_rds to create the object for his tutorial. -->


<div class="tutorial-exercise" data-label="courage-5" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"><script type="application/json" data-ui-opts="1">{"engine":"r","has_checker":false,"caption":"<span data-i18n=\"text.enginecap\" data-i18n-opts=\"{&quot;engine&quot;:&quot;R&quot;}\">R Code<\/span>"}</script></div>

<div class="tutorial-exercise-support" data-label="courage-5-hint-1" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"></div>

<!-- XX: Note how there is no test case. If there were one, then a student would fit the model each time she hit "Run Tutorial." That takes too much time. -->

### 

### Exercise 6

Behind the scenes, we have assigned the result of the `brm()` call to an object named `fit_postcard_vote`. Type `fit_postcard_vote` and hit "Run Code." This generates the same results as using `print(fit_postcard_vote)`.


<div class="tutorial-exercise" data-label="courage-6" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"><script type="application/json" data-ui-opts="1">{"engine":"r","has_checker":false,"caption":"<span data-i18n=\"text.enginecap\" data-i18n-opts=\"{&quot;engine&quot;:&quot;R&quot;}\">R Code<\/span>"}</script></div>

<div class="tutorial-exercise-support" data-label="courage-6-hint-1" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;">

``` text
fit_postcard_vote
```

</div>



### 

<!-- XX Same some general words about the object. Note that we are about to go through the top 4 rows. -->


### Exercise 7

Run `family()` on `fit_postcard_vote`. `family()` provides information about the "family" of the error term and the link between it and the dependent variable. 

<div class="tutorial-exercise" data-label="courage-7" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"><script type="application/json" data-ui-opts="1">{"engine":"r","has_checker":false,"caption":"<span data-i18n=\"text.enginecap\" data-i18n-opts=\"{&quot;engine&quot;:&quot;R&quot;}\">R Code<\/span>"}</script></div>

<div class="tutorial-exercise-support" data-label="courage-7-hint-1" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;">

``` text
family(...)
```

</div>



### 

<!-- XX: This is a great location for explanations which get much more detailed in later chapters. That is, we want students to have a more sophisticated understanding of probability distributions, and there use in modeling, as we move through the Primer.

But, at a minimum, you would comment about how the family that is shown --- which is either gaussian, bernoulli or categorical --- is determined by the family argument which you passed in to the brm() call, and that you determined that by looking at the distribution of the output variable. Continuous means gaussian, 2 possible values means bernoullu, and 2+ possible values means categorical.

-->

In this case, XX . . .

### Exercise 8

Run `formula()` on `fit_postcard_vote`. `formula()` returns the statistical equation which relates the dependent variable to the independent variable(s). 

<div class="tutorial-exercise" data-label="courage-8" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"><script type="application/json" data-ui-opts="1">{"engine":"r","has_checker":false,"caption":"<span data-i18n=\"text.enginecap\" data-i18n-opts=\"{&quot;engine&quot;:&quot;R&quot;}\">R Code<\/span>"}</script></div>

<div class="tutorial-exercise-support" data-label="courage-8-hint-1" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;">

``` text
formula(...)
```

</div>



### 

In this case, XX . . .

### Exercise 9

Run `nobs()` on `fit_postcard_vote`. The `nobs()` function returns the **n**umber of **obs**ervations.

<div class="tutorial-exercise" data-label="courage-9" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"><script type="application/json" data-ui-opts="1">{"engine":"r","has_checker":false,"caption":"<span data-i18n=\"text.enginecap\" data-i18n-opts=\"{&quot;engine&quot;:&quot;R&quot;}\">R Code<\/span>"}</script></div>

<div class="tutorial-exercise-support" data-label="courage-9-hint-1" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;">

``` text
nobs(...)
```

</div>



### 

In this case, XX

### Exercise 10

Write the mathematical formula for your model, using $\LaTeX$ math notation.


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="courage-10" class="tutorial-question panel-body">
<div id="courage-10-answer_container" class="shiny-html-output"></div>
<div id="courage-10-message_container" class="shiny-html-output"></div>
<div id="courage-10-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

Add the formula to `causal_effect.qmd`. `Command/Ctrl + Shift + K`. Ensure that the formula is looks correct. 

### Exercise 11

Create a new code chunk in `causal_effect.qmd`. Add two code chunk options: `label: model` and `cache: true`. Copy/paste the code from above for estimating the model using `brm()` into the code chunk, assining the result to `fit_postcard_vote`. 

`Command/Ctrl + Shift + K`. It may take some time to render `causal_effect.qmd`, depending on how complex your model is. But, by including `cache: true` you cause Quarto to cache the results of the chunk. The next time you render `causal_effect.qmd`, as long as you have not changed the code, Quarto will just load up the saved fitted object.

To confirm, `Command/Ctrl + Shift + K` again. It should be quick.

At the Console, run:

```
tutorial.helpers::show_file("causal_effect.qmd", start = -8)
```

CP/CR.


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="courage-11" class="tutorial-question panel-body">
<div id="courage-11-answer_container" class="shiny-html-output"></div>
<div id="courage-11-message_container" class="shiny-html-output"></div>
<div id="courage-11-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

### Exercise 12

Run `posterior_interval()` on `fit_postcard_vote`. The `posterior_interval()` function returns 95% intervals for all the parameters in our model.

<div class="tutorial-exercise" data-label="courage-12" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"><script type="application/json" data-ui-opts="1">{"engine":"r","has_checker":false,"caption":"<span data-i18n=\"text.enginecap\" data-i18n-opts=\"{&quot;engine&quot;:&quot;R&quot;}\">R Code<\/span>"}</script></div>

<div class="tutorial-exercise-support" data-label="courage-12-hint-1" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;">

``` text
posterior_interval(...)
```

</div>



### 

In this case, XX . . .


### Exercise 13

Run `fixef()` on `fit_postcard_vote`. The `fixef()` returns information about the **fix**ed **ef**fects in the model.

<div class="tutorial-exercise" data-label="courage-13" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"><script type="application/json" data-ui-opts="1">{"engine":"r","has_checker":false,"caption":"<span data-i18n=\"text.enginecap\" data-i18n-opts=\"{&quot;engine&quot;:&quot;R&quot;}\">R Code<\/span>"}</script></div>

<div class="tutorial-exercise-support" data-label="courage-13-hint-1" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;">

``` text
fixef(...)
```

</div>



### 

In this case, XX . . .

<!-- XX: Consider adding questions about conditional_effects(), ranef() and other commands, if relevant. -->

### Exercise 14

Run `pp_check()` on `fit_postcard_vote`. The `pp_check()` runs a **p**osterior **p**redictive check.

<div class="tutorial-exercise" data-label="courage-14" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"><script type="application/json" data-ui-opts="1">{"engine":"r","has_checker":false,"caption":"<span data-i18n=\"text.enginecap\" data-i18n-opts=\"{&quot;engine&quot;:&quot;R&quot;}\">R Code<\/span>"}</script></div>

<div class="tutorial-exercise-support" data-label="courage-14-hint-1" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;">

``` text
pp_check(...)
```

</div>



### 

In this case, XX

<!-- If the fake data had looked very different from the real data, we have had a problem. But, for the most part, we conclude that, although not perfect, pp_check() shows that the fake outcomes generated by our model are like the actual outcome data. -->


### Exercise 15

Use `library()` to load the [**gtsummary**](https://www.danieldsjoberg.com/gtsummary) package.

<div class="tutorial-exercise" data-label="courage-15" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"><script type="application/json" data-ui-opts="1">{"engine":"r","has_checker":false,"caption":"<span data-i18n=\"text.enginecap\" data-i18n-opts=\"{&quot;engine&quot;:&quot;R&quot;}\">R Code<\/span>"}</script></div>

<div class="tutorial-exercise-support" data-label="courage-15-hint-1" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;">

``` text
library(gtsummary)
```

</div>



### 

<!-- Drop some knowledge about gtsummary. Or say something more about your DGM. -->

### Exercise 16

<!-- XX: This can be just one question or several, especially if you want to teach some more gtsummary or gt tricks. Make any adjustments to this question, like `intercept = TRUE`, so that this question works. -->

Pipe `fit_postcard_vote` to `tbl_regression()`.


<div class="tutorial-exercise" data-label="courage-16" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"><script type="application/json" data-ui-opts="1">{"engine":"r","has_checker":false,"caption":"<span data-i18n=\"text.enginecap\" data-i18n-opts=\"{&quot;engine&quot;:&quot;R&quot;}\">R Code<\/span>"}</script></div>

<div class="tutorial-exercise-support" data-label="courage-16-hint-1" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;">

``` text
fit_postcard_vote |> 
  tbl_...()
```

</div>



### 

<!-- XX: Drop some knowledge about what you have learned by looking at the resulting table. Of course, you could have learned the same thing when you first took a look at fit_postcard_vote. But the table makes it easier to see the relationships between the variables and the outcome. With luck, students will take the hint when they answer the next question. -->

<!-- https://www.danieldsjoberg.com/gtsummary/articles/tbl_regression.html -->


### Exercise 17

Write a few sentence which summarize your work so far. The first few sentences are the same as what you had at the end of the Justice Section. Add one sentence which describes the modelling approach which you are using, specifying the functional form and the dependent variable. Add one sentence which describes the *direction* (not the magnitude) of the relationship between one of your independent variables and your dependent variable.


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="courage-17" class="tutorial-question panel-body">
<div id="courage-17-answer_container" class="shiny-html-output"></div>
<div id="courage-17-message_container" class="shiny-html-output"></div>
<div id="courage-17-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

### Exercise 18

Update `causal_effect.qmd`. First, add `library(gtsummary)` to the `setup` code chunk,. Second, add the mathematical formula, in $\LaTeX$ and surrounded by double dollar signs, for your model. Third, add a new code chunk which creates the table of model parameters. `Command/Ctrl + Shift + K` to ensure that everything works.

At the Console, run:

```
tutorial.helpers::show_file("causal_effect.qmd", start = -8)
```

CP/CR.


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="courage-18" class="tutorial-question panel-body">
<div id="courage-18-answer_container" class="shiny-html-output"></div>
<div id="courage-18-message_container" class="shiny-html-output"></div>
<div id="courage-18-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

## Temperance
### 

<!-- XX: Choose one. -->

*Temperance is a tree which as for its root very little contentment, and for its fruit calm and peace.* - Buddha
*Temperance is the greatest of all virtues. It subdues every passion and emotion, and almost creates a Heaven upon Earth.* - Joseph Smith Jr.
*Temperance is a bridle of gold; he, who uses it rightly, is more like a god than a man.* - Robert Burton
*Temperance is the firm and moderate dominion of reason over passion and other unrighteous impulses of the mind.* - Marcus Tullius Cicero
*Temperance to be a virtue must be free, and not forced.* - Philip Massinger
*Temperance is simply a disposition of the mind which binds the passion.* - Thomas Aquinas


### Exercise 1

In your own words, describe the use of Temperance in data science.


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="temperance-1" class="tutorial-question panel-body">
<div id="temperance-1-answer_container" class="shiny-html-output"></div>
<div id="temperance-1-message_container" class="shiny-html-output"></div>
<div id="temperance-1-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

### Exercise 2

What is the general topic we are investigating? What is the specific question we are trying to answer? 


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="temperance-2" class="tutorial-question panel-body">
<div id="temperance-2-answer_container" class="shiny-html-output"></div>
<div id="temperance-2-message_container" class="shiny-html-output"></div>
<div id="temperance-2-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

Data science projects almost always begin with a broad topic of interest. Yet, in order to make progress, we need to drill down to a specific question. This leads to the creation of a data generating mechanism, which can now be used to answer lots of questions, thus allowing us to explore the original topic broadly.

### Exercise 3

To answer our question, we need to create a `newdata` object. Which variables do we need to include in this object?


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="temperance-3" class="tutorial-question panel-body">
<div id="temperance-3-answer_container" class="shiny-html-output"></div>
<div id="temperance-3-message_container" class="shiny-html-output"></div>
<div id="temperance-3-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

<!-- XX -->

### Exercise 4

Which values do you want the variables in your `newdata` object to have? This is not easy! 


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="temperance-4" class="tutorial-question panel-body">
<div id="temperance-4-answer_container" class="shiny-html-output"></div>
<div id="temperance-4-message_container" class="shiny-html-output"></div>
<div id="temperance-4-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

### Exercise 5

Here is the R code which creates the `newdata` object: `tibble(whatever) code here`. Type it into the code exercise block and hit "Run Code."

<!-- Asking students to create this object --- even after you help them figure out the columns, rows and values --- is too hard, at least until they get more experiences. Your knowledge drop, for this question and the next, should give them advice on the broad topic of how they can create newdata objects themselves. -->

<div class="tutorial-exercise" data-label="temperance-5" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"><script type="application/json" data-ui-opts="1">{"engine":"r","has_checker":false,"caption":"<span data-i18n=\"text.enginecap\" data-i18n-opts=\"{&quot;engine&quot;:&quot;R&quot;}\">R Code<\/span>"}</script></div>

<div class="tutorial-exercise-support" data-label="temperance-5-hint-1" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"></div>



### 

### Exercise 6

Behind the scenes, we have created the `ndata` object using this code. To confirm, type `ndata` and hit "Run Code."

<!-- Of course, you need to have added the code to create `ndata` in the setup chunk at the top of the file. -->

<div class="tutorial-exercise" data-label="temperance-6" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"><script type="application/json" data-ui-opts="1">{"engine":"r","has_checker":false,"caption":"<span data-i18n=\"text.enginecap\" data-i18n-opts=\"{&quot;engine&quot;:&quot;R&quot;}\">R Code<\/span>"}</script></div>

<div class="tutorial-exercise-support" data-label="temperance-6-hint-1" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"></div>



### 

### Exercise 7

Now that we have the `newdata` object, we can create a pipe which uses out fitted model to answer our question. Begin by typing `fit_postcard_vote` and clicking "Run Code."

<div class="tutorial-exercise" data-label="temperance-7" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"><script type="application/json" data-ui-opts="1">{"engine":"r","has_checker":false,"caption":"<span data-i18n=\"text.enginecap\" data-i18n-opts=\"{&quot;engine&quot;:&quot;R&quot;}\">R Code<\/span>"}</script></div>

<div class="tutorial-exercise-support" data-label="temperance-7-hint-1" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"></div>



### 

<!-- XX: Again, the main point of knowledge drops is this area is to explain to students why the newdata object looks the way it does and what it will produce. A great way to teach is via example. That is, explaining that if we had another way with these values, then we would get this posterior. Or, explaining what would be produced if we used add_epred instead of add_predict, and vice verse. -->


### Exercise 8

Pipe `fit_postcard_vote` to [XX: either `add_epred_draws()` or `add_predicted_draws()`] with the argument `newdata = ndata`.



<div class="tutorial-exercise" data-label="temperance-8" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"><script type="application/json" data-ui-opts="1">{"engine":"r","has_checker":false,"caption":"<span data-i18n=\"text.enginecap\" data-i18n-opts=\"{&quot;engine&quot;:&quot;R&quot;}\">R Code<\/span>"}</script></div>

<button onclick = "transfer_code(this)">Copy previous code</button>

<div class="tutorial-exercise-support" data-label="temperance-8-hint-1" data-completion="1" data-diagnostics="1" data-startover="1" data-lines="0" data-pipe="|&gt;"></div>



### 

<!-- XX: How do students know whether to use add_epred_draws or add_predicted_draws? This is non-trivial. On some level, we just tell them with the above command. (We don't make them guess.) But we also address this issue explicitly in various knowledg drops, especially this one. -->

<!-- XX: Insert as many questions as necessary to build a nice-looking example of your final plot. In early chapters, this is simple since our questions are simple. They are just one posterior. In later chapters, they become more complex, with the inclusion of several posteriors, as well as manipulation of them to calculate causal effects and whatnot. See the voting postcard example. -->

### Exercise 9

Create a new code chunk in `causal_effect.qmd`. Label it with `label: plot`. Copy/paste the code which creates your graphic. `Command/Ctrl + Shift + K` to ensure that it all works as intended.

At the Console, run:

```
tutorial.helpers::show_file("causal_effect.qmd", start = -8)
```

CP/CR.


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="temperance-9" class="tutorial-question panel-body">
<div id="temperance-9-answer_container" class="shiny-html-output"></div>
<div id="temperance-9-message_container" class="shiny-html-output"></div>
<div id="temperance-9-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

### Exercise 10

Write a paragraph which summarizes the project in your own words. The first few sentences are the same as what you had at the end of the Courage section. But, since your question may have evolved, you should feel free to change those sentences. Add at least one sentence which describes at least one quantity of interest (QoI) --- presumably one that answers your question -- and which provides a measure of uncertainty about that QoI.

<!-- XX: Most of the time, there will be some measure of uncertainty associated with your QoI. But not always! The most common counter-example involves a question which asks about the odds or probability of something happening. We would answer such a question by simulating the event with `add_predicted_draws()`. We would then calculate the odds/probability of something happening by seeing how many of the 4,000 draws met the criteria for the event. Assume that was 40%. So, we think that there is a 40% chance that event A will happen. Yet there is no uncertainty associated with that estimate because it, itself, is an expression of uncertainty. (DK: Flesh this out further.) -->


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="temperance-10" class="tutorial-question panel-body">
<div id="temperance-10-answer_container" class="shiny-html-output"></div>
<div id="temperance-10-message_container" class="shiny-html-output"></div>
<div id="temperance-10-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

Edit the summary paragrpah in `causal_effect.qmd` as you see fit, but do not copy/paste our answer exactly. `Command/Ctrl + Shift + K`.


<!-- XX: Again, spend time to make your recommended paragraph perfect. Study the examples in https://ppbds.github.io/primer/cardinal-virtues.html closely. -->

### Exercise 11

Write a few sentences which explain why the estimates for the quantities of interest, and the uncertainty thereof, might be wrong. Suggest an alternative estimate and confidence interval, if you think either might be warranted.


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="temperance-11" class="tutorial-question panel-body">
<div id="temperance-11-answer_container" class="shiny-html-output"></div>
<div id="temperance-11-message_container" class="shiny-html-output"></div>
<div id="temperance-11-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

### Exercise 12

Publish `causal_effect.qmd` to Rpubs. Choose a sensible slug. Copy/paste the url below.


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="temperance-12" class="tutorial-question panel-body">
<div id="temperance-12-answer_container" class="shiny-html-output"></div>
<div id="temperance-12-message_container" class="shiny-html-output"></div>
<div id="temperance-12-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

### Exercise 13

Rearrange the material in `causal_effect.qmd` so that the order is graphic, paragraph, math and table. Doing so, of course, requires sensible judgment. For example, the code chunk which creates the fitted model must occur before the chunk which creates the graphic. `Command/Ctrl + Shift + K` to ensure that everything works.

At the Console, run:

```
tutorial.helpers::show_file("causal_effect.qmd")
```

CP/CR.


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="temperance-13" class="tutorial-question panel-body">
<div id="temperance-13-answer_container" class="shiny-html-output"></div>
<div id="temperance-13-message_container" class="shiny-html-output"></div>
<div id="temperance-13-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

### 

Add `rsconnect` to the `.gitignore` file. You don't want your personal Rpubs details stored in the clear on Github. Commit/push everything.


## Summary
### 

This tutorial covered [Chapter XX: XX](https://ppbds.github.io/primer/XX.html) of [*Preceptor’s Primer for Bayesian Data Science: Using the Cardinal Virtues for Inference*](https://ppbds.github.io/primer/) by [David Kane](https://davidkane.info/). 




## Download answers


```{=html}
<div class="panel panel-default tutorial-question-container">
<div data-label="minutes" class="tutorial-question panel-body">
<div id="minutes-answer_container" class="shiny-html-output"></div>
<div id="minutes-message_container" class="shiny-html-output"></div>
<div id="minutes-action_button_container" class="shiny-html-output"></div>
<script>if (Tutorial.triggerMathJax) Tutorial.triggerMathJax()</script>
</div>
</div>
```

###


```{=html}
<div>
When you have completed this tutorial, follow these steps:
<br/>
<ol>
<li>Click the button to download a file containing your answers.</li>
<li>Save the file onto your computer in a convenient location.</li>
</ol>
<div class="container-fluid">
<div class="col-sm-8" role="main">
<div id="form">
<a id="downloadHtml" class="btn btn-default shiny-download-link " href="" target="_blank" download>
<i class="fas fa-download" role="presentation" aria-label="download icon"></i>
Download HTML
</a>
</div>
</div>
</div>
<div>
<br/>
(If no file seems to download, try clicking with the alternative button on the download button and choose "Save link as...")
<br/>
</div>
</div>
```


preserve5d808a6beddd27b7
preserve9bac9d1c9febdc95
preservefa171ca902c9240a
preservef3585cc357fef0d3
preservead4fe30871b8d76a
preservec396be075e2b77f9
preservec5b740f559da0386
preserve12899e2febc0c9fd
preserve3deb06e78fdd059e
preserve748c019a0f67b88f
preserve0fa0d60adea9e4be
preservede89c0c9fc8614e9
preserved7f92c0c4874fd0c
preserve0d55e5dd8b468b76
preservefb84b730e400b8a4
preserve9fb8d106ec11db0d
preserve098584ac40a616fe
preserved756dbf1d83d4766
preservee86bc5ec4e1bf7da
preservef6d408da1b200b5c
preservee39db7647295b955
preserve92f12f5fb2cde54a
preservea0312ed75637f6aa
preserve49c18ab3c3a7b591
preserve826560a69d82093e
preservec1a71cc5c3ef69b7
preservefcd522ac79a8286d
preservec796242fd1675466
preservefb93ee83781aff1a
preserve1b5174ac1e5176bc
preservecc681119dd338630
preserveb549be36d2fcc8bf
preserveae9982f490ac41fe
preservec17d31155965922c
preserve27921a9f1c91cea2
preserve8126cda711a4b300
preserve242ae00d0fc62604
preserve69dcb97878627305
preserve8d1c5f88c6b79ec1
preserve0e44dcf6084716b6
preservefea030c16a53d3ea
preserveedd789dd4a939001
preservea3305870bb66c820
preserve381c68b9321b5f0e
preserve54f9a8369adb405a
preserve7692ac330ca66118
preserve6c111516b08f460f
preservea7d54b87b99d1e6f
preserved7d62d698dbdecaf
preserve6f5e156d4fb87280
preserve4f24c7c6a1299407
preserve4549f28d3c2d1f26
preserve1c86875ea76c931d
preserve5f2e2067bb698062
preserve4cee22fc871b61c9
preserve9c6ec96111f8308d
preserve46a395b8dc85406d
preserve819260f8f153c7c8
preserve0429b57356f9a8fe
preservec3d98eb6fff474d1
preserve36cba1f5be17618b
preserve025e8ab0ad771eee
preservee7ae3e2d9d9898f9
preservef305ae3b219aa6d1
preserveeed9768c619dbf4e
preserve6b4330e78b475b19
preservee4c813ae53742e71
preserve7a94fb87dc26e602
preserve205adaf6e08fd995
preserve03bf51ca6094644f
preserve36e33db605da6d9a
preserve43dd9d700ab48ecc
preservea4a3d43f83ed6db6
preserveaf44ff136e728379
preservef35b1593796e6bea
preservea7d74c636459e784
preserve0fd5e987a7222159
preserved7a826ff745f043b
preserve094a147714d36f70
preserve6ef02ab60a1e885f
preserve9e1803df00d94b1a
preservef33e5272fad4b6dc
preserved117095c2c5a93f6
preserveb708aab8997ebb1c
preservec8f344ced3d7a89e
preserve5def7247321a7e52
preserveedaebf10db61af35
preserveb3ebd4bd4917a9d6
preservef352994a57a34afa
preservecfe69e14295d509e
preservee8a57242f4c4a6bb
preserve92048184d15e3dc8
preserve86fe232928ae6bd7
preserve670b0cd6db3585a8
preserve77d7c850342987a9
preserveebed12558e279d6f
preservec3513553fe39580e
preserve5515c2a510d92880
preservea80c7e364803f3d4
preserve486226aedbe13f3d
preserve2bf9e205dbdbfd13
preserve6f0c818e10129833
preserve4ebeb0825087c92c
preserve9cffe1a064e11d61
preserveecded7fdc9108e29
preservece9ed14b2f4178ce
preserve34b85a7a2dbc18cc
preserve5a22e243145475fe

<!--html_preserve-->
<script type="application/shiny-prerendered" data-context="dependencies">
{"type":"list","attributes":{},"value":[{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["header-attrs"]},{"type":"character","attributes":{},"value":["2.27"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["rmd/h/pandoc"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["header-attrs.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["rmarkdown"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["2.27"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["jquery"]},{"type":"character","attributes":{},"value":["3.6.0"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/3.6.0"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["jquery-3.6.0.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["jquerylib"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.1.4"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["bootstrap"]},{"type":"character","attributes":{},"value":["3.3.5"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["rmd/h/bootstrap"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["viewport"]}},"value":[{"type":"character","attributes":{},"value":["width=device-width, initial-scale=1"]}]},{"type":"character","attributes":{},"value":["js/bootstrap.min.js","shim/html5shiv.min.js","shim/respond.min.js"]},{"type":"character","attributes":{},"value":["css/cerulean.min.css"]},{"type":"character","attributes":{},"value":["<style>h1 {font-size: 34px;}\n       h1.title {font-size: 38px;}\n       h2 {font-size: 30px;}\n       h3 {font-size: 24px;}\n       h4 {font-size: 18px;}\n       h5 {font-size: 16px;}\n       h6 {font-size: 12px;}\n       code {color: inherit; background-color: rgba(0, 0, 0, 0.04);}\n       pre:not([class]) { background-color: white }<\/style>"]},{"type":"NULL"},{"type":"character","attributes":{},"value":["rmarkdown"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["2.27"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["pagedtable"]},{"type":"character","attributes":{},"value":["1.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["rmd/h/pagedtable-1.1"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["js/pagedtable.js"]},{"type":"character","attributes":{},"value":["css/pagedtable.css"]},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["rmarkdown"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["2.27"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["highlightjs"]},{"type":"character","attributes":{},"value":["9.12.0"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["rmd/h/highlightjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["highlight.js"]},{"type":"character","attributes":{},"value":["textmate.css"]},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["rmarkdown"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["2.27"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["tutorial"]},{"type":"character","attributes":{},"value":["0.11.5"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/tutorial"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["tutorial.js"]},{"type":"character","attributes":{},"value":["tutorial.css"]},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["i18n"]},{"type":"character","attributes":{},"value":["21.6.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/i18n"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["i18next.min.js","tutorial-i18n-init.js"]},{"type":"NULL"},{"type":"character","attributes":{},"value":["<script id=\"i18n-cstm-trns\" type=\"application/json\">{\"language\":\"en\",\"resources\":{\"en\":{\"translation\":{\"button\":{\"runcode\":\"Run Code\",\"runcodetitle\":\"$t(button.runcode) ({{kbd}})\",\"hint\":\"Hint\",\"hint_plural\":\"Hints\",\"hinttitle\":\"$t(button.hint)\",\"hintnext\":\"Next Hint\",\"hintprev\":\"Previous Hint\",\"solution\":\"Solution\",\"solutiontitle\":\"$t(button.solution)\",\"copyclipboard\":\"Copy to Clipboard\",\"startover\":\"Start Over\",\"startovertitle\":\"$t(button.startover)\",\"continue\":\"Continue\",\"submitanswer\":\"Submit Answer\",\"submitanswertitle\":\"$t(button.submitanswer)\",\"previoustopic\":\"Previous Topic\",\"nexttopic\":\"Next Topic\",\"questionsubmit\":\"$t(button.submitanswer)\",\"questiontryagain\":\"Try Again\"},\"text\":{\"startover\":\"Start Over\",\"areyousure\":\"Are you sure you want to start over? (all exercise progress will be reset)\",\"youmustcomplete\":\"You must complete the\",\"exercise\":\"exercise\",\"exercise_plural\":\"exercises\",\"inthissection\":\"in this section before continuing.\",\"code\":\"Code\",\"enginecap\":\"{{engine}} $t(text.code)\",\"quiz\":\"Quiz\",\"blank\":\"blank\",\"blank_plural\":\"blanks\",\"exercisecontainsblank\":\"This exercise contains {{count}} $t(text.blank).\",\"pleasereplaceblank\":\"Please replace {{blank}} with valid code.\",\"unparsable\":\"It looks like this might not be valid R code. R cannot determine how to turn your text into a complete command. You may have forgotten to fill in a blank, to remove an underscore, to include a comma between arguments, or to close an opening <code>&quot;<\\/code>, <code>'<\\/code>, <code>(<\\/code> or <code>{<\\/code> with a matching <code>&quot;<\\/code>, <code>'<\\/code>, <code>)<\\/code> or <code>}<\\/code>.\\n\",\"unparsablequotes\":\"<p>It looks like your R code contains specially formatted quotation marks or &quot;curly&quot; quotes (<code>{{character}}<\\/code>) around character strings, making your code invalid. R requires character values to be contained in straight quotation marks (<code>&quot;<\\/code> or <code>'<\\/code>).<\\/p> {{code}} <p>Don't worry, this is a common source of errors when you copy code from another app that applies its own formatting to text. You can try replacing the code on that line with the following. There may be other places that need to be fixed, too.<\\/p> {{suggestion}}\\n\",\"unparsableunicode\":\"<p>It looks like your R code contains an unexpected special character (<code>{{character}}<\\/code>) that makes your code invalid.<\\/p> {{code}} <p>Sometimes your code may contain a special character that looks like a regular character, especially if you copy and paste the code from another app. Try deleting the special character from your code and retyping it manually.<\\/p>\\n\",\"unparsableunicodesuggestion\":\"<p>It looks like your R code contains an unexpected special character (<code>{{character}}<\\/code>) that makes your code invalid.<\\/p> {{code}} <p>Sometimes your code may contain a special character that looks like a regular character, especially if you copy and paste the code from another app. You can try replacing the code on that line with the following. There may be other places that need to be fixed, too.<\\/p> {{suggestion}}\\n\",\"and\":\"and\",\"or\":\"or\",\"listcomma\":\", \",\"oxfordcomma\":\",\"}}},\"fr\":{\"translation\":{\"button\":{\"runcode\":\"Lancer le Code\",\"runcodetitle\":\"$t(button.runcode) ({{kbd}})\",\"hint\":\"Indication\",\"hint_plural\":\"Indications\",\"hinttitle\":\"$t(button.hint)\",\"hintnext\":\"Indication Suivante\",\"hintprev\":\"Indication Précédente\",\"solution\":\"Solution\",\"solutiontitle\":\"$t(button.solution)\",\"copyclipboard\":\"Copier dans le Presse-papier\",\"startover\":\"Recommencer\",\"startovertitle\":\"$t(button.startover)\",\"continue\":\"Continuer\",\"submitanswer\":\"Soumettre\",\"submitanswertitle\":\"$t(button.submitanswer)\",\"previoustopic\":\"Chapitre Précédent\",\"nexttopic\":\"Chapitre Suivant\",\"questionsubmit\":\"$t(button.submitanswer)\",\"questiontryagain\":\"Réessayer\"},\"text\":{\"startover\":\"Recommencer\",\"areyousure\":\"Êtes-vous certains de vouloir recommencer? (La progression sera remise à zéro)\",\"youmustcomplete\":\"Vous devez d'abord compléter\",\"exercise\":\"l'exercice\",\"exercise_plural\":\"des exercices\",\"inthissection\":\"de cette section avec de continuer.\",\"code\":\"Code\",\"enginecap\":\"$t(text.code) {{engine}}\",\"quiz\":\"Quiz\",\"and\":\"et\",\"or\":\"ou\",\"oxfordcomma\":\"\"}}},\"es\":{\"translation\":{\"button\":{\"runcode\":\"Ejecutar código\",\"runcodetitle\":\"$t(button.runcode) ({{kbd}})\",\"hint\":\"Pista\",\"hint_plural\":\"Pistas\",\"hinttitle\":\"$t(button.hint)\",\"hintnext\":\"Siguiente pista\",\"hintprev\":\"Pista anterior\",\"solution\":\"Solución\",\"solutiontitle\":\"$t(button.solution)\",\"copyclipboard\":\"Copiar al portapapeles\",\"startover\":\"Reiniciar\",\"startovertitle\":\"$t(button.startover)\",\"continue\":\"Continuar\",\"submitanswer\":\"Enviar respuesta\",\"submitanswertitle\":\"$t(button.submitanswer)\",\"previoustopic\":\"Tema anterior\",\"nexttopic\":\"Tema siguiente\",\"questionsubmit\":\"$t(button.submitanswer)\",\"questiontryagain\":\"Volver a intentar\"},\"text\":{\"startover\":\"Reiniciar\",\"areyousure\":\"¿De verdad quieres empezar de nuevo? (todo el progreso del ejercicio se perderá)\",\"youmustcomplete\":\"Debes completar\",\"exercise\":\"el ejercicio\",\"exercise_plural\":\"los ejercicios\",\"inthissection\":\"en esta sección antes de continuar.\",\"code\":\"Código\",\"enginecap\":\"$t(text.code) {{engine}}\",\"quiz\":\"Cuestionario\",\"and\":\"y\",\"or\":\"o\",\"oxfordcomma\":\"\"}}},\"pt\":{\"translation\":{\"button\":{\"runcode\":\"Executar código\",\"runcodetitle\":\"$t(button.runcode) ({{kbd}})\",\"hint\":\"Dica\",\"hint_plural\":\"Dicas\",\"hinttitle\":\"$t(button.hint)\",\"hintnext\":\"Próxima dica\",\"hintprev\":\"Dica anterior\",\"solution\":\"Solução\",\"solutiontitle\":\"$t(button.solution)\",\"copyclipboard\":\"Copiar para a área de transferência\",\"startover\":\"Reiniciar\",\"startovertitle\":\"$t(button.startover)\",\"continue\":\"Continuar\",\"submitanswer\":\"Enviar resposta\",\"submitanswertitle\":\"$t(button.submitanswer)\",\"previoustopic\":\"Tópico anterior\",\"nexttopic\":\"Próximo tópico\",\"questionsubmit\":\"$t(button.submitanswer)\",\"questiontryagain\":\"Tentar novamente\"},\"text\":{\"startover\":\"Reiniciar\",\"areyousure\":\"Tem certeza que deseja começar novamente? (todo o progresso feito será perdido)\",\"youmustcomplete\":\"Você deve completar\",\"exercise\":\"o exercício\",\"exercise_plural\":\"os exercícios\",\"inthissection\":\"nesta seção antes de continuar.\",\"code\":\"Código\",\"enginecap\":\"$t(text.code) {{engine}}\",\"quiz\":\"Quiz\",\"and\":\"e\",\"or\":\"ou\",\"oxfordcomma\":\"\"}}},\"tr\":{\"translation\":{\"button\":{\"runcode\":\"Çalıştırma Kodu\",\"runcodetitle\":\"$t(button.runcode) ({{kbd}})\",\"hint\":\"Ipucu\",\"hint_plural\":\"İpuçları\",\"hinttitle\":\"$t(button.hint)\",\"hintnext\":\"Sonraki İpucu\",\"hintprev\":\"Önceki İpucu\",\"solution\":\"Çözüm\",\"solutiontitle\":\"$t(button.solution)\",\"copyclipboard\":\"Pano'ya Kopyala\",\"startover\":\"Baştan Başlamak\",\"startovertitle\":\"$t(button.startover)\",\"continue\":\"Devam et\",\"submitanswer\":\"Cevabı onayla\",\"submitanswertitle\":\"$t(button.submitanswer)\",\"previoustopic\":\"Önceki Konu\",\"nexttopic\":\"Sonraki Konu\",\"questionsubmit\":\"$t(button.submitanswer)\",\"questiontryagain\":\"Tekrar Deneyin\"},\"text\":{\"startover\":\"Baştan Başlamak\",\"areyousure\":\"Baştan başlamak istediğinizden emin misiniz? (tüm egzersiz ilerlemesi kaybolacak)\",\"youmustcomplete\":\"Tamamlamalısın\",\"exercise\":\"egzersiz\",\"exercise_plural\":\"egzersizler\",\"inthissection\":\"devam etmeden önce bu bölümde\",\"code\":\"Kod\",\"enginecap\":\"$t(text.code) {{engine}}\",\"quiz\":\"Sınav\",\"oxfordcomma\":\"\"}}},\"emo\":{\"translation\":{\"button\":{\"runcode\":\"🏃\",\"runcodetitle\":\"$t(button.runcode) ({{kbd}})\",\"hint\":\"💡\",\"hint_plural\":\"$t(button.hint)\",\"hinttitle\":\"$t(button.hint)\",\"solution\":\"🎯\",\"solutiontitle\":\"$t(button.solution)\",\"copyclipboard\":\"📋\",\"startover\":\"⏮\",\"startovertitle\":\"Start Over\",\"continue\":\"✅\",\"submitanswer\":\"🆗\",\"submitanswertitle\":\"Submit Answer\",\"previoustopic\":\"⬅\",\"nexttopic\":\"➡\",\"questionsubmit\":\"$t(button.submitanswer)\",\"questiontryagain\":\"🔁\"},\"text\":{\"startover\":\"⏮\",\"areyousure\":\"🤔\",\"youmustcomplete\":\"⚠️ 👉 🧑‍💻\",\"exercise\":\"\",\"exercise_plural\":\"\",\"inthissection\":\"\",\"code\":\"💻\",\"enginecap\":\"$t(text.code) {{engine}}\",\"oxfordcomma\":\"\"}}},\"eu\":{\"translation\":{\"button\":{\"runcode\":\"Kodea egikaritu\",\"runcodetitle\":\"$t(button.runcode) ({{kbd}})\",\"hint\":\"Laguntza\",\"hint_plural\":\"Laguntza\",\"hinttitle\":\"$t(button.hint)\",\"hintnext\":\"Aurreko laguntza\",\"hintprev\":\"Hurrengo laguntza\",\"solution\":\"Ebazpena\",\"solutiontitle\":\"$t(button.solution)\",\"copyclipboard\":\"Arbelean kopiatu\",\"startover\":\"Berrabiarazi\",\"startovertitle\":\"$t(button.startover)\",\"continue\":\"Jarraitu\",\"submitanswer\":\"Erantzuna bidali\",\"submitanswertitle\":\"$t(button.submitanswer)\",\"previoustopic\":\"Aurreko atala\",\"nexttopic\":\"Hurrengo atala\",\"questionsubmit\":\"$t(button.submitanswer)\",\"questiontryagain\":\"Berriro saiatu\"},\"text\":{\"startover\":\"Berrabiarazi\",\"areyousure\":\"Berriro hasi nahi duzu? (egindako lana galdu egingo da)\",\"youmustcomplete\":\"Aurrera egin baino lehen atal honetako\",\"exercise\":\"ariketa egin behar duzu.\",\"exercise_plural\":\"ariketak egin behar dituzu.\",\"inthissection\":\"\",\"code\":\"Kodea\",\"enginecap\":\"$t(text.code) {{engine}}\",\"quiz\":\"Galdetegia\",\"oxfordcomma\":\"\"}}},\"de\":{\"translation\":{\"button\":{\"runcode\":\"Code ausführen\",\"runcodetitle\":\"$t(button.runcode) ({{kbd}})\",\"hint\":\"Tipp\",\"hint_plural\":\"Tipps\",\"hinttitle\":\"$t(button.hint)\",\"hintnext\":\"Nächster Tipp\",\"hintprev\":\"Vorheriger Tipp\",\"solution\":\"Lösung\",\"solutiontitle\":\"$t(button.solution)\",\"copyclipboard\":\"In die Zwischenablage kopieren\",\"startover\":\"Neustart\",\"startovertitle\":\"$t(button.startover)\",\"continue\":\"Weiter\",\"submitanswer\":\"Antwort einreichen\",\"submitanswertitle\":\"$t(button.submitanswer)\",\"previoustopic\":\"Vorheriges Kapitel\",\"nexttopic\":\"Nächstes Kapitel\",\"questionsubmit\":\"$t(button.submitanswer)\",\"questiontryagain\":\"Nochmal versuchen\"},\"text\":{\"startover\":\"Neustart\",\"areyousure\":\"Bist du sicher, dass du neustarten willst? (der gesamte Lernfortschritt wird gelöscht)\",\"youmustcomplete\":\"Vervollstädinge\",\"exercise\":\"die Übung\",\"exercise_plural\":\"die Übungen\",\"inthissection\":\"in diesem Kapitel, bevor du fortfährst.\",\"code\":\"Code\",\"enginecap\":\"$t(text.code) {{engine}}\",\"quiz\":\"Quiz\",\"blank\":\"Lücke\",\"blank_plural\":\"Lücken\",\"pleasereplaceblank\":\"Bitte ersetze {{blank}} mit gültigem Code.\",\"unparsable\":\"Dies scheint kein gültiger R Code zu sein. R kann deinen Text nicht in einen gültigen Befehl übersetzen. Du hast vielleicht vergessen, die Lücke zu füllen, einen Unterstrich zu entfernen, ein Komma zwischen Argumente zu setzen oder ein eröffnendes <code>&quot;<\\/code>, <code>'<\\/code>, <code>(<\\/code> oder <code>{<\\/code> mit einem zugehörigen <code>&quot;<\\/code>, <code>'<\\/code>, <code>)<\\/code> oder <code>}<\\/code> zu schließen.\\n\",\"and\":\"und\",\"or\":\"oder\",\"listcomma\":\", \",\"oxfordcomma\":\",\"}}},\"ko\":{\"translation\":{\"button\":{\"runcode\":\"코드 실행\",\"runcodetitle\":\"$t(button.runcode) ({{kbd}})\",\"hint\":\"힌트\",\"hint_plural\":\"힌트들\",\"hinttitle\":\"$t(button.hint)\",\"hintnext\":\"다음 힌트\",\"hintprev\":\"이전 힌트\",\"solution\":\"솔루션\",\"solutiontitle\":\"$t(button.solution)\",\"copyclipboard\":\"클립보드에 복사\",\"startover\":\"재학습\",\"startovertitle\":\"$t(button.startover)\",\"continue\":\"다음 학습으로\",\"submitanswer\":\"정답 제출\",\"submitanswertitle\":\"$t(button.submitanswer)\",\"previoustopic\":\"이전 토픽\",\"nexttopic\":\"다음 토픽\",\"questionsubmit\":\"$t(button.submitanswer)\",\"questiontryagain\":\"재시도\"},\"text\":{\"startover\":\"재학습\",\"areyousure\":\"다시 시작 하시겠습니까? (모든 예제의 진행 정보가 재설정됩니다)\",\"youmustcomplete\":\"당신은 완료해야 합니다\",\"exercise\":\"연습문제\",\"exercise_plural\":\"연습문제들\",\"inthissection\":\"이 섹션을 실행하기 전에\",\"code\":\"코드\",\"enginecap\":\"$t(text.code) {{engine}}\",\"quiz\":\"퀴즈\",\"blank\":\"공백\",\"blank_plural\":\"공백들\",\"exercisecontainsblank\":\"이 연습문제에는 {{count}}개의 $t(text.blank)이 포함되어 있습니다.\",\"pleasereplaceblank\":\"{{blank}}를 유효한 코드로 바꾸십시오.\",\"unparsable\":\"이것은 유효한 R 코드가 아닐 수 있습니다. R은 텍스트를 완전한 명령으로 변환하는 방법을 결정할 수 없습니다. 당신은 공백이나 밑줄을 대체하여 채우기, 인수를 컴마로 구분하기, 또는 <code>&quot;<\\/code>, <code>'<\\/code>, <code>(<\\/code> , <code>{<\\/code>로 시작하는 구문을 닫는 <code>&quot;<\\/code>, <code>'<\\/code>, <code>)<\\/code>, <code>}<\\/code>을 잊었을 수도 있습니다.\\n\",\"and\":\"그리고\",\"or\":\"혹은\",\"listcomma\":\", \",\"oxfordcomma\":\"\"}}},\"zh\":{\"translation\":{\"button\":{\"runcode\":\"运行代码\",\"runcodetitle\":\"$t(button.runcode) ({{kbd}})\",\"hint\":\"提示\",\"hint_plural\":\"提示\",\"hinttitle\":\"$t(button.hint)\",\"hintnext\":\"下一个提示\",\"hintprev\":\"上一个提示\",\"solution\":\"答案\",\"solutiontitle\":\"$t(button.solution)\",\"copyclipboard\":\"复制到剪切板\",\"startover\":\"重新开始\",\"startovertitle\":\"$t(button.startover)\",\"continue\":\"继续\",\"submitanswer\":\"提交答案\",\"submitanswertitle\":\"$t(button.submitanswer)\",\"previoustopic\":\"上一专题\",\"nexttopic\":\"下一专题\",\"questionsubmit\":\"$t(button.submitanswer)\",\"questiontryagain\":\"再试一次\"},\"text\":{\"startover\":\"重置\",\"areyousure\":\"你确定要重新开始吗? (所有当前进度将被重置)\",\"youmustcomplete\":\"你必须完成\",\"exercise\":\"练习\",\"exercise_plural\":\"练习\",\"inthissection\":\"在进行本节之前\",\"code\":\"代码\",\"enginecap\":\"$t(text.code) {{engine}}\",\"quiz\":\"测试\",\"blank\":\"空\",\"blank_plural\":\"空\",\"exercisecontainsblank\":\"本练习包含{{count}}个$t(text.blank)\",\"pleasereplaceblank\":\"请在{{blank}}内填写恰当的代码\",\"unparsable\":\"这似乎不是有效的R代码。 R不知道如何将您的文本转换为完整的命令。 您是否忘了填空，忘了删除下划线，忘了在参数之间包含逗号，或者是忘了用<code>&quot;<\\/code>, <code>'<\\/code>, <code>)<\\/code>,<code>}<\\/code>来封闭<code>&quot;<\\/code>, <code>'<\\/code>, <code>(<\\/code>。 or <code>{<\\/code>。\\n\",\"unparsablequotes\":\"<p>您的R代码中似乎含有特殊格式的引号，或者弯引号(<code>{{character}}<\\/code>) 在字符串前后，在R中字符串应该被直引号(<code>&quot;<\\/code> 或者 <code>'<\\/code>)包裹。<\\/p> {{code}} <p>别担心，该错误经常在复制粘贴包含格式的代码时遇到， 您可以尝试将该行中的代码替换为以下代码，也许还有其他地方需要修改。<\\/p> {{suggestion}}\\n\",\"unparsableunicode\":\"<p>您的代码中似乎包含有异常字符(<code>{{character}}<\\/code>),导致代码无效。<\\/p> {{code}} <p>有时候你的代码可能含有看似正常字符的特殊字符，特别是当你复制粘贴其他来源代码的时候。 请试着删除这些特殊字符,重新输入<\\/p>\\n\",\"unparsableunicodesuggestion\":\"<p>您的代码中似乎包含有异常字符(<code>{{character}}<\\/code>),导致代码无效。<\\/p> {{code}} <p>有时候你的代码可能含有看似正常字符的特殊字符，特别是当你复制粘贴其他来源代码的时候。 请试着删除这些特殊字符,重新输入<\\/p>\\n\",\"and\":\"且\",\"or\":\"或\",\"listcomma\":\",\",\"oxfordcomma\":\",\"}}},\"pl\":{\"translation\":{\"button\":{\"runcode\":\"Uruchom kod\",\"runcodetitle\":\"$t(button.runcode) ({{kbd}})\",\"hint\":\"Podpowiedź\",\"hint_plural\":\"Podpowiedzi\",\"hinttitle\":\"$t(button.hint)\",\"hintnext\":\"Następna podpowiedź\",\"hintprev\":\"Poprzednia podpowiedź\",\"solution\":\"Rozwiązanie\",\"solutiontitle\":\"$t(button.solution)\",\"copyclipboard\":\"Kopiuj do schowka\",\"startover\":\"Zacznij od początku\",\"startovertitle\":\"$t(button.startover)\",\"continue\":\"Kontynuuj\",\"submitanswer\":\"Wyślij\",\"submitanswertitle\":\"$t(button.submitanswer)\",\"previoustopic\":\"Poprzednia sekcja\",\"nexttopic\":\"Następna sekcja\",\"questionsubmit\":\"$t(button.submitanswer)\",\"questiontryagain\":\"Spróbuj ponownie\"},\"text\":{\"startover\":\"Zacznij od początku\",\"areyousure\":\"Czy na pewno chcesz zacząć od początku? (cały postęp w zadaniu zostanie utracony)\",\"youmustcomplete\":\"Musisz ukończyć\",\"exercise\":\"ćwiczenie\",\"exercise_plural\":\"ćwiczenia\",\"inthissection\":\"w tej sekcji przed kontynuowaniem\",\"code\":\"Kod\",\"enginecap\":\"$t(text.code) {{engine}}\",\"quiz\":\"Quiz\",\"blank\":\"luka\",\"blank_plural\":\"luk(i)\",\"exercisecontainsblank\":\"To ćwiczenie zawiera {{count}} $t(text.blank).\",\"pleasereplaceblank\":\"Proszę uzupełnić {{blank}} prawidłowym kodem.\",\"unparsable\":\"Wygląda na to, że może to nie być prawidłowy kod R. R nie jest w stanie przetworzyć Twojego tekstu na polecenie. Mogłeś(-aś) zapomnieć wypełnić luki, usunąć podkreślnik, umieścić przecinka między argumentami, lub zamknąć znak <code>&quot;<\\/code>, <code>'<\\/code>, <code>(<\\/code> lub <code>{<\\/code> odpowiadającym <code>&quot;<\\/code>, <code>'<\\/code>, <code>)<\\/code> lub <code>}<\\/code>.\\n\",\"unparsablequotes\":\"<p>Wygląda na to, że Twój kod zawiera szczególnie sformatowane cudzysłowy lub cudzysłowy typograficzne (<code>{{character}}<\\/code>) przy ciągach znaków, co sprawia, że kod jest niepoprawny. R wymaga cudzysłowów prostych (<code>&quot;<\\/code> albo <code>'<\\/code>).<\\/p> {{code}} <p>Nie martw się, to powszechne źródło błędów, gdy kopiuje się kod z innego programu, który sam formatuje teskt. Możesz spróbować zastąpić swój kod następującym kodem. Mogą być też inne miejsca, które wymagają poprawienia.<\\/p> {{suggestion}}\\n\",\"unparsableunicode\":\"<p>Wygląda na to, że Twój kod zawiera niespodziewany znak specjalny (<code>{{character}}<\\/code>), co sprawia, że kod jest niepoprawny.<\\/p> {{code}} <p>Czasami Twój kod może zawierać znak specjalny, który wygląda jak zwykły znak, zwłaszcza jeśli kopiujesz kod z innego programu. Spróbuj usunąć znak specjalny i wpisać do ponownie ręcznie.<\\/p>\\n\",\"unparsableunicodesuggestion\":\"<p>Wygląda na to, że Twój kod zawiera niespodziewany znak specjalny (<code>{{character}}<\\/code>), co sprawia, że kod jest niepoprawny.<\\/p> {{code}} <p>Czasami Twój kod może zawierać znak specjalny, który wygląda jak zwykły znak, zwłaszcza jeśli kopiujesz kod z innego programu. Możesz spróbować zastąpić swój kod następującym kodem. Mogą być też inne miejsca, które wymagają poprawienia.<\\/p> {{suggestion}}\\n\",\"and\":\"i\",\"or\":\"lub\",\"listcomma\":\", \",\"oxfordcomma\":\"\"}}}}}<\/script>"]},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["tutorial-format"]},{"type":"character","attributes":{},"value":["0.11.5"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["rmarkdown/templates/tutorial/resources"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["tutorial-format.js"]},{"type":"character","attributes":{},"value":["tutorial-format.css","rstudio-theme.css"]},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["jquery"]},{"type":"character","attributes":{},"value":["3.6.0"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/3.6.0"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["jquery-3.6.0.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["jquerylib"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.1.4"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["navigation"]},{"type":"character","attributes":{},"value":["1.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["rmd/h/navigation-1.1"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["tabsets.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["rmarkdown"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["2.27"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["highlightjs"]},{"type":"character","attributes":{},"value":["9.12.0"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["rmd/h/highlightjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["highlight.js"]},{"type":"character","attributes":{},"value":["default.css"]},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["rmarkdown"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["2.27"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["jquery"]},{"type":"character","attributes":{},"value":["3.6.0"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/3.6.0"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["jquery-3.6.0.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["jquerylib"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.1.4"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["font-awesome"]},{"type":"character","attributes":{},"value":["6.4.2"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["fontawesome"]}]},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["css/all.min.css","css/v4-shims.min.css"]},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["fontawesome"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.5.2"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["bootbox"]},{"type":"character","attributes":{},"value":["5.5.2"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/bootbox"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["bootbox.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["idb-keyvalue"]},{"type":"character","attributes":{},"value":["3.2.0"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/idb-keyval"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["idb-keyval-iife-compat.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[false]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["tutorial"]},{"type":"character","attributes":{},"value":["0.11.5"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/tutorial"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["tutorial.js"]},{"type":"character","attributes":{},"value":["tutorial.css"]},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["ace"]},{"type":"character","attributes":{},"value":["1.10.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/ace"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["ace.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["clipboardjs"]},{"type":"character","attributes":{},"value":["2.0.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/clipboardjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["clipboard.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["ace"]},{"type":"character","attributes":{},"value":["1.10.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/ace"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["ace.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["clipboardjs"]},{"type":"character","attributes":{},"value":["2.0.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/clipboardjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["clipboard.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["ace"]},{"type":"character","attributes":{},"value":["1.10.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/ace"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["ace.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["clipboardjs"]},{"type":"character","attributes":{},"value":["2.0.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/clipboardjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["clipboard.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["ace"]},{"type":"character","attributes":{},"value":["1.10.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/ace"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["ace.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["clipboardjs"]},{"type":"character","attributes":{},"value":["2.0.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/clipboardjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["clipboard.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["ace"]},{"type":"character","attributes":{},"value":["1.10.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/ace"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["ace.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["clipboardjs"]},{"type":"character","attributes":{},"value":["2.0.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/clipboardjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["clipboard.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["ace"]},{"type":"character","attributes":{},"value":["1.10.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/ace"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["ace.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["clipboardjs"]},{"type":"character","attributes":{},"value":["2.0.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/clipboardjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["clipboard.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["ace"]},{"type":"character","attributes":{},"value":["1.10.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/ace"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["ace.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["clipboardjs"]},{"type":"character","attributes":{},"value":["2.0.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/clipboardjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["clipboard.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["ace"]},{"type":"character","attributes":{},"value":["1.10.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/ace"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["ace.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["clipboardjs"]},{"type":"character","attributes":{},"value":["2.0.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/clipboardjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["clipboard.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["ace"]},{"type":"character","attributes":{},"value":["1.10.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/ace"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["ace.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["clipboardjs"]},{"type":"character","attributes":{},"value":["2.0.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/clipboardjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["clipboard.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["ace"]},{"type":"character","attributes":{},"value":["1.10.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/ace"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["ace.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["clipboardjs"]},{"type":"character","attributes":{},"value":["2.0.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/clipboardjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["clipboard.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["ace"]},{"type":"character","attributes":{},"value":["1.10.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/ace"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["ace.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["clipboardjs"]},{"type":"character","attributes":{},"value":["2.0.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/clipboardjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["clipboard.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["ace"]},{"type":"character","attributes":{},"value":["1.10.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/ace"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["ace.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["clipboardjs"]},{"type":"character","attributes":{},"value":["2.0.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/clipboardjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["clipboard.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["ace"]},{"type":"character","attributes":{},"value":["1.10.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/ace"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["ace.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["clipboardjs"]},{"type":"character","attributes":{},"value":["2.0.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/clipboardjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["clipboard.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["ace"]},{"type":"character","attributes":{},"value":["1.10.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/ace"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["ace.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["clipboardjs"]},{"type":"character","attributes":{},"value":["2.0.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/clipboardjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["clipboard.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["ace"]},{"type":"character","attributes":{},"value":["1.10.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/ace"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["ace.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["clipboardjs"]},{"type":"character","attributes":{},"value":["2.0.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/clipboardjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["clipboard.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["ace"]},{"type":"character","attributes":{},"value":["1.10.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/ace"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["ace.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["clipboardjs"]},{"type":"character","attributes":{},"value":["2.0.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/clipboardjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["clipboard.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["ace"]},{"type":"character","attributes":{},"value":["1.10.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/ace"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["ace.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["clipboardjs"]},{"type":"character","attributes":{},"value":["2.0.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/clipboardjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["clipboard.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["ace"]},{"type":"character","attributes":{},"value":["1.10.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/ace"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["ace.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["clipboardjs"]},{"type":"character","attributes":{},"value":["2.0.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/clipboardjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["clipboard.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["ace"]},{"type":"character","attributes":{},"value":["1.10.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/ace"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["ace.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["clipboardjs"]},{"type":"character","attributes":{},"value":["2.0.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/clipboardjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["clipboard.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["ace"]},{"type":"character","attributes":{},"value":["1.10.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/ace"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["ace.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["clipboardjs"]},{"type":"character","attributes":{},"value":["2.0.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/clipboardjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["clipboard.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["ace"]},{"type":"character","attributes":{},"value":["1.10.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/ace"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["ace.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["clipboardjs"]},{"type":"character","attributes":{},"value":["2.0.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/clipboardjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["clipboard.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["ace"]},{"type":"character","attributes":{},"value":["1.10.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/ace"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["ace.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["clipboardjs"]},{"type":"character","attributes":{},"value":["2.0.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/clipboardjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["clipboard.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["ace"]},{"type":"character","attributes":{},"value":["1.10.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/ace"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["ace.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["clipboardjs"]},{"type":"character","attributes":{},"value":["2.0.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/clipboardjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["clipboard.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["ace"]},{"type":"character","attributes":{},"value":["1.10.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/ace"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["ace.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["clipboardjs"]},{"type":"character","attributes":{},"value":["2.0.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/clipboardjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["clipboard.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["ace"]},{"type":"character","attributes":{},"value":["1.10.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/ace"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["ace.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["clipboardjs"]},{"type":"character","attributes":{},"value":["2.0.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/clipboardjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["clipboard.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["ace"]},{"type":"character","attributes":{},"value":["1.10.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/ace"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["ace.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["clipboardjs"]},{"type":"character","attributes":{},"value":["2.0.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/clipboardjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["clipboard.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["ace"]},{"type":"character","attributes":{},"value":["1.10.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/ace"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["ace.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["clipboardjs"]},{"type":"character","attributes":{},"value":["2.0.10"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["lib/clipboardjs"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["clipboard.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["learnr"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.11.5"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["jquery"]},{"type":"character","attributes":{},"value":["3.6.0"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["www/shared"]}]},{"type":"NULL"},{"type":"character","attributes":{},"value":["jquery.min.js"]},{"type":"NULL"},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["shiny"]},{"type":"logical","attributes":{},"value":[false]},{"type":"character","attributes":{},"value":["1.8.1.1"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["font-awesome"]},{"type":"character","attributes":{},"value":["6.4.2"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["fontawesome"]}]},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["css/all.min.css","css/v4-shims.min.css"]},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["fontawesome"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["0.5.2"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["name","version","src","meta","script","stylesheet","head","attachment","package","all_files","pkgVersion"]},"class":{"type":"character","attributes":{},"value":["html_dependency"]}},"value":[{"type":"character","attributes":{},"value":["bootstrap"]},{"type":"character","attributes":{},"value":["3.4.1"]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["file"]}},"value":[{"type":"character","attributes":{},"value":["www/shared/bootstrap"]}]},{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["viewport"]}},"value":[{"type":"character","attributes":{},"value":["width=device-width, initial-scale=1"]}]},{"type":"character","attributes":{},"value":["js/bootstrap.min.js","accessibility/js/bootstrap-accessibility.min.js"]},{"type":"character","attributes":{},"value":["css/bootstrap.min.css","accessibility/css/bootstrap-accessibility.min.css"]},{"type":"NULL"},{"type":"NULL"},{"type":"character","attributes":{},"value":["shiny"]},{"type":"logical","attributes":{},"value":[true]},{"type":"character","attributes":{},"value":["1.8.1.1"]}]}]}
</script>
<!--/html_preserve-->
<!--html_preserve-->
<script type="application/shiny-prerendered" data-context="execution_dependencies">
{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["packages"]}},"value":[{"type":"list","attributes":{"names":{"type":"character","attributes":{},"value":["packages","version"]},"class":{"type":"character","attributes":{},"value":["data.frame"]},"row.names":{"type":"integer","attributes":{},"value":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114]}},"value":[{"type":"character","attributes":{},"value":["abind","arrayhelpers","backports","base","bayesplot","bridgesampling","brms","Brobdingnag","broom.helpers","bslib","cachem","checkmate","cli","coda","codetools","colorspace","commonmark","compiler","curl","datasets","digest","distributional","dplyr","ellipsis","evaluate","fansi","farver","fastmap","fontawesome","forcats","generics","ggdist","ggplot2","glue","graphics","grDevices","grid","gridExtra","gt","gtable","gtsummary","highr","hms","htmltools","htmlwidgets","httpuv","httr","inline","jquerylib","jsonlite","knitr","later","lattice","learnr","lifecycle","loo","lubridate","magrittr","markdown","Matrix","matrixStats","methods","mime","munsell","mvtnorm","nlme","parallel","pillar","pkgbuild","pkgconfig","posterior","primer.data","promises","purrr","QuickJSR","R6","Rcpp","RcppParallel","readr","rlang","rmarkdown","rprojroot","rstan","rstantools","rstudioapi","rvest","sass","scales","shiny","StanHeaders","stats","stats4","stringi","stringr","svUnit","tensorA","tibble","tidybayes","tidyr","tidyselect","tidyverse","timechange","tools","tutorial.helpers","tzdb","utf8","utils","V8","vctrs","withr","xfun","xml2","xtable","yaml"]},{"type":"character","attributes":{},"value":["1.4-5","1.1-0","1.5.0","4.4.0","1.11.1","1.1-2","2.21.0","1.2-9","1.15.0","0.7.0","1.1.0","2.3.1","3.6.3","0.19-4.1","0.2-20","2.1-0","1.9.1","4.4.0","5.2.1","4.4.0","0.6.36","0.4.0","1.1.4","0.3.2","0.24.0","1.0.6","2.1.2","1.2.0","0.5.2","1.0.0","0.1.3","3.3.2","3.5.1","1.7.0","4.4.0","4.4.0","4.4.0","2.3","0.11.0","0.3.5","1.7.2","0.11","1.1.3","0.5.8.1","1.6.4","1.6.15","1.4.7","0.3.19","0.1.4","1.8.8","1.48","1.3.2","0.22-6","0.11.5","1.0.4","2.7.0","1.9.3","2.0.3","1.13","1.7-0","1.3.0","4.4.0","0.12","0.5.1","1.2-5","3.1-165","4.4.0","1.9.0","1.4.4","2.0.3","1.5.0","0.7.2.9005","1.3.0","1.0.2","1.2.2","2.5.1","1.0.12","5.1.7","2.1.5","1.1.4","2.27","2.0.4","2.32.6","2.4.0","0.16.0","1.0.4","0.4.9","1.3.0","1.8.1.1","2.32.9","4.4.0","4.4.0","1.8.4","1.5.1","1.0.6","0.36.2.1","3.2.1","3.0.6","1.3.1","1.2.1","2.0.0","0.3.0","4.4.0","0.3.0","0.4.0","1.2.4","4.4.0","4.4.2","0.6.5","3.0.0","0.45","1.3.6","1.8-4","2.3.9"]}]}]}
</script>
<!--/html_preserve-->
