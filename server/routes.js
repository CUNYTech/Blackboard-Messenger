import express from 'express';
const routes = express();

// Controller Imports
import userController from './controllers/userController';
import basicController from './controllers/basicController';;
// User Routes
routes.get('/', basicController.get);

routes.post('/users/sign_in', userController.post);

export default routes;
