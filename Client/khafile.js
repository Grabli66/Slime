let project = new Project('New Project');
project.addAssets('Assets/**');
project.addSources('Sources');
project.addSources('Sources/Physics');
project.addLibrary('nape');
resolve(project);
