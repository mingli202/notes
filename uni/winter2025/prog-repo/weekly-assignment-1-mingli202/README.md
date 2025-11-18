[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/y_4aqIQE)
# Weekly Assignment 1: Learning The Basics of GitHub 

## :octocat: Git and GitHub

Git is a **distributed Version Control System (VCS)**, which means it is a useful tool for easily tracking changes to your code, collaborating, and sharing. With Git you can track the changes you make to your project so you always have a record of what you’ve worked on and can easily revert back to an older version if need be. It also makes working with others easier—groups of people can work together on the same project and merge their changes into one final source!

GitHub is a way to use the same power of Git all online with an easy-to-use interface. It’s used across the software world and beyond to collaborate and maintain the history of projects.

GitHub is home to some of the most advanced technologies in the world. Whether you're visualizing data or building a new game, there's a whole community and set of tools on GitHub that can get you to the next step. This course starts with the basics of GitHub, but we'll dig into the rest later.

## :octocat: Understanding the GitHub flow 

The GitHub flow is a lightweight workflow that allows you to experiment and collaborate on your projects easily, without the risk of losing your previous work.

### Repositories

A repository is where your project work happens--think of it as your project folder. It contains all of your project’s files and revision history.  You can work within a repository alone or invite others to collaborate with you on those files.

Repositories also contain **README**s. You can add a README file to your repository to tell other people why your project is useful, what they can do with your project, and how they can use it. We are using this README to communicate how to learn Git and GitHub with you. 😄 
To learn more about repositories read ["Creating, Cloning, and Archiving Repositories](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/about-repositories) and ["About README's"](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/about-readmes). 

### Cloning 

When a repository is created with GitHub, it’s stored remotely in the ☁️. You can clone a repository to create a local copy on your computer and then use Git to sync the two. This makes it easier to fix issues, add or remove files, and push larger commits. You can also use the editing tool of your choice as opposed to the GitHub UI. Cloning a repository also pulls down all the repository data that GitHub has at that point in time, including all versions of every file and folder for the project! This can be helpful if you experiment with your project and then realize you liked a previous version more. 
To learn more about cloning, read ["Cloning a Repository"](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository). 

### Committing and pushing
**Committing** and **pushing** are how you can add the changes you made on your local machine to the remote repository in GitHub. That way your instructor and/or teammates can see your latest work when you’re ready to share it. You can make a commit when you have made changes to your project that you want to “checkpoint.” You can also add a helpful **commit message** to remind yourself or your teammates what work you did (e.g. “Added a README with information about our project”).

Once you have a commit or multiple commits that you’re ready to add to your repository, you can use the push command to add those changes to your remote repository. Committing and pushing may feel new at first, but we promise you’ll get used to it 🙂

Now that you have some basic understanding of Git and GitHub, before getting to the next part, please use the following link to fill out a form on your information such as you student ID and GitHub username and email ["Information form"](https://forms.office.com/Pages/ResponsePage.aspx?id=cZYxzedSaEqvqfz4-J8J6gTd9jPfD65CmAXl7XdQApRUQ09BVzVGSDhKTEtTRk9YTEU4VUFHU09VRS4u
).
## 📝 Deliverables
**Friendly Reminder: Please fill up [this form](https://forms.office.com/Pages/ResponsePage.aspx?id=cZYxzedSaEqvqfz4-J8J6gTd9jPfD65CmAXl7XdQApRUQ09BVzVGSDhKTEtTRk9YTEU4VUFHU09VRS4u) so that we know which student ID corresponds to your GitHub username!**
1. Clone this repository by following the instructions [here](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository). Setup GitHub to use ssh keys by following the instructions [here](https://github.com/McGill-ECSE250-2025W/Weekly-Assignment1-Template/blob/main/docs/ssh-key-guide.md). Observe that a folder with the following naming pattern `tutorial01-*` (with * being your GitHub username) will be created.
2. Complete the program with the source code located at `src/HelloWorldClass.java`. The program is expected to output `Hello World!` to the console.
3. Open up the terminal application, and navigate to the `tutorial01-*` folder.
4. Perform the following commands:
```bash
git add src/HelloWorldClass.java
git commit -m "This is my first Java code!"
git push
```

## 📚  Additional Resources
* [A short video explaining what GitHub is](https://www.youtube.com/watch?v=w3jLJU7DT5E&feature=youtu.be) 
* [Git and GitHub learning resources](https://docs.github.com/en/github/getting-started-with-github/git-and-github-learning-resources) 
* [Understanding the GitHub flow](https://guides.github.com/introduction/flow/)
* [Interactive Git training materials](https://githubtraining.github.io/training-manual/#/01_getting_ready_for_class)
* [GitHub's Learning Lab](https://github.com/apps/github-learning-lab)
* [Education community forum](https://education.github.community/)
* [GitHub community forum](https://github.community/)

## Sources
* This README is modified from the [original GitHub starter course](https://github.com/classroom-resources/github-starter-course)

