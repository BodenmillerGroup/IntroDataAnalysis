# Git Workshop Guide

# Activity 1: Create and Clone a New Repository

### Part 1: Create a New Repository

- Navigate to your GitHub **profile page**
- In the top menu bar, select **Repositories**
- In the top right, click the green **New** button

On the "Create a new repository" page:

- **Name:** Give your repository any name you like. If you need a suggestion, GitHub will give you one!
- **Public or Private:** It doesn't matter for now
- **"Initialize this repository with a README"** box: check! ☑️
- **"Add .gitignore"** drop down: select Python
- Create repository

### Part 2: Clone a Repository

On your new repository page:

- Click the green Clone or download button
- Click the 📋clipboard icon next to the URL to copy your GitHub repo's URL

In your terminal:

- Navigate with `cd` to where you want to have your repository.
    - If you want to create a new directory for all your git repos:  `mkdir githubs`
- Run `git clone <the url you copied>`
- When it finishes, run `cd <the name of your repo>`, and then `ls -a`.
- There should be the following files:
    - [`README.md`](http://readme.md)  - Since we asked GitHub to initialize this repo with a readme
    - `.git/` - This is where all the git information is stored!
    - `.gitignore` - This is a file that tells what git should ignore. We'll get to this later.

---

# Activity 2: Add and Modify files


Cheat Sheet!

### Part 1: Add a New File

In your terminal:

- (Make sure you're located in your git repository directory)
- Run `echo "Hello world" > hello.txt` to create a text file with the contents "Hello world".
    - Run `git status` - note that `hello.txt` is listed as **Untracked**. This means git is not paying attention to this file.

- Run `git add hello.txt` to tell git to pay attention to this file!
    - Run `git status` - note that `hello.txt` is listed as **Changes to be committed**.

- Run `git commit -m "first commit"` to make a commit.

    If this is your first time using git, you'll have to set your name and email address in order to commit. Follow the instructions git gives you, and then run the commit command again. 

    - Run `git status` - note that git says "nothing to commit". This is git's way of saying "no unsaved changes".
    - If you look at your repo's GitHub page right now, `hello.txt` won't be there yet, because you haven't *pushed* it to GitHub yet.

- Run `git push`

In your browser:

- Reload your repo's GitHub page. `hello.txt` should be there!

### Part 2: Modify a File

Now, open `hello.txt` in your favorite text editor, and add more text! Save the file. 

In your terminal:

- Run `git status` - `hello.txt` should now be listed as **Changes not staged for commit**. This means git is paying attention to this file, and there are new changes that haven't been committed yet. But if you commit right now, those changes won't be included in the commit.
- Test out running `git status -s` to get a shorter version of git status. Note that `hello.txt` has an `M`, for *modified*.

- Run `git add hello.txt` to tell git to *stage* your new changes.
    - Run `git status` - note that `hello.txt` is listed as **Changes to be committed**.
    - Run `git status -s.` Note that `hello.txt` has an `A`, for *added*.

- Run `git commit -m "summarize what you changed here"` to make a commit.
    - Run `git status` - note that git says "nothing to commit". This is git's way of saying "no unsaved changes".

- Run `git push`

In your browser:

- Reload your repo's GitHub page, and click on `hello.txt`. Your new text should be there!

Tip: use `git add -p` to go through all of your changes "hunk by hunk"

---

# Activity 3: Create a Branch and Open a Pull Request

### Part 1: Create a Branch

- Clone the [group test repository](https://github.com/nilseling/GithubTest). If you forget how to do that, refer to Activity 1, Part 2.

In your terminal:

- Navigate to the `GithubTest` repository
- Run `git checkout -b your_last_name_here`
- Add a new file to the repo. Name the file with your last name (this is so that no two people create the same file).
- `git add lastname.txt` and `git commit -m "lastname"` and `git push` to add your new file to the repo.
- Run `git push --set-upstream origin your_last_name_here` to push the new file *on your new branch* to GitHub. This command is a little different than normal because the new branch you created is not yet in GitHub, and you have to tell GitHub about it.
    - FYI: If you forget to do this special command and just do a `git push`, that's ok! GitHub will give you an error message that shows you exactly what to run, like this:

            fatal: The current branch master has no upstream branch.
            To push the current branch and set the remote as upstream, use
            
                 git push --set-upstream origin branch_name

### Part 2: Open a Pull Request

In your browser:

- Refresh the page. Your new file isn't there, because you're looking at the **master** branch.
- Change branches using the dropdown in the top left. Right now it should say **"Branch: master"**. Change it to your branch. Confirm that your new file is there!
- Right next to the Branch dropdown, there's a **"New pull request"** button. Click it!

On the "Open a pull request" page:

- You can give your Pull Request a snazzy title and description.
- Below the comment box, take a look in the **Files Changed** tab. This gives you a nice diff of what's changing in this Pull Request
- In the Reviewers section on the left, put Laura, Jonas, or Nils. Here are their usernames:
    - Laura: `lokijuhy`
    - Jonas: `jwindhager`
    - Nils: `nilseling`
- Click that big green **Create pull request** button!

Wait for Laura/Nils/Jonas to tell you they've approved your Pull Request. Then, refresh the page. You should see that your pull request has been approved. You can click **Merge pull request**. 

Go back to the main repo page, and switch back to viewing the **master** branch. You should see your new file, as well as others!
