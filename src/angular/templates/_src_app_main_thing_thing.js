'use strict';

import ThingService from './thing.service';
import ThingDirective from './thing.directive';
import ThingController from './thing.controller';

export default angular.module('$FIXME$.Thing', [])
.service('ThingService', ThingService)
.directive('thing', ThingDirective)
.controller('ThingController', ThingController);
