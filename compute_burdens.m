function compute_burdens(varargin)
%COMPUTE_BURDENS Compute burden estimates for common architectures
%   COMPUTE_BURDENS computes estimates of the memory and computational 
%   requirements of a set of common convolutional neural network architectures.
%
%   COMPUTE_BURDENS(..'name', value) accepts the following 
%   options:
%
%   `includeClassifiers` :: true
%    Compute burden estimates for common image classification architectures.
%
%   `includeObjDetectors` :: false
%    Compute burden estimates for common object detection architectures.
%
%   `includeSegmenters` :: false
%    Compute burden estimates for a few semantic segmentation architectures.
%
%   `includeKeypointDetectors` :: false
%    Compute burden estimates for a few keypoint detection architectures.
%
% Copyright (C) 2017 Samuel Albanie 
% Licensed under The MIT License [see LICENSE.md for details]

  opts.includeClassifiers = true ;
  opts.includeObjDetectors = false ;
  opts.includeSegmenters = false ;
  opts.includeKeypointDetectors = false ;
  opts.logDir = fullfile(vl_rootnn, 'data/burden') ;
  modelDir = fullfile(vl_rootnn, 'data/models-import') ;
  opts = vl_argparse(opts, varargin) ;

  models = {} ; logName = 'log' ;

  if opts.includeClassifiers
    models = [ models { ...
       {'imagenet-matconvnet-alex.mat', [227 227]}, ...
       {'imagenet-caffe-ref.mat', [224 224]},...
       {'squeezenet1_0-pt-mcn.mat', [224 224]},...
       {'squeezenet1_1-pt-mcn.mat', [224 224]},...
       {'imagenet-vgg-f.mat', [224 224]},...
       {'imagenet-vgg-m.mat', [224 224]},...
       {'imagenet-vgg-s.mat', [224 224]},...
       {'imagenet-vgg-m-2048.mat', [224 224]},...
       {'imagenet-vgg-m-1024.mat', [224 224]},...
       {'imagenet-vgg-m-128.mat', [224 224]},...
       {'vgg-vd-16-reduced.mat', [224 224]},...
       {'imagenet-vgg-verydeep-16.mat', [224 224]},...
       {'imagenet-vgg-verydeep-19.mat', [224 224]},...
       {'imagenet-googlenet-dag.mat', [224 224]},...
       {'imagenet-resnet-50-dag.mat', [224 224]},...
       {'imagenet-resnet-101-dag.mat', [224 224]},...
       {'imagenet-resnet-152-dag.mat', [224 224]},...
       {'resnext_50_32x4d-pt-mcn.mat', [224 224]},...
       {'resnext_101_32x4d-pt-mcn.mat', [224 224]},...
       {'resnext_101_64x4d-pt-mcn.mat', [224 224]},...
       } ] ;
    logName = [ logName '-cls'] ;
   end

  if opts.includeObjDetectors
    models = [ models { ...
     {'rfcn-res50-pascal', [600 850]}, ...
     {'rfcn-res101-pascal', [600 850]}, ...
     {'ssd-mcn-pascal-vggvd-300.mat', [300 300]}, ...
     {'ssd-mcn-pascal-vggvd-512.mat', [512 512]}, ...
     {'faster-rcnn-vggvd-pascal', [600 850]}, ...
     } ] ;
    logName = [logName '-det'] ;
   end

  if opts.includeSegmenters
    models = [ models { ...
     {'pascal-fcn32s-dag.mat', [384 384]}, ...
     {'pascal-fcn16s-dag.mat', [384 384]}, ...
     {'pascal-fcn8s-dag.mat', [384 384]}, ...
     } ] ;
    logName = [logName '-seg'] ;
  end

  if opts.includeKeypointDetectors
    models = [ models { ...
     {'multipose-mpi.mat', [368 368]}, ...
     {'multipose-coco.mat', [368 368]}, ...
     } ] ;
    logName = [logName '-key'] ;
  end

  if ~exist(opts.logDir, 'dir'), mkdir(opts.logDir) ; end
  logFile = fullfile(opts.logDir, [logName '.txt']) ;
  diary(logFile) ; diary on ;

  for ii = 1:numel(models)
    modelPath = fullfile(modelDir, models{ii}{1}) ;
    burden('modelPath', modelPath, 'imsz', models{ii}{2}) ;
  end
  diary off ;
