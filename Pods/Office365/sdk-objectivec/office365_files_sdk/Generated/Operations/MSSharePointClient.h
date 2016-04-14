/*******************************************************************************
 * Copyright (c) Microsoft Open Technologies, Inc.
 * All Rights Reserved
 * Licensed under the Apache License, Version 2.0.
 * See License.txt in the project root for license information.
 *
 * Warning: This code was generated automatically. Edits will be overwritten.
 * To make changes to this code, please make changes to the generation framework itself:
 * https://github.com/MSOpenTech/odata-codegen
 *******************************************************************************/

#import <office365_odata_base/office365_odata_base.h>
#import "MSSharePointDriveFetcher.h"
#import "MSSharePointItemCollectionFetcher.h"


/**
* The header for type MSSharePointClient.
*/

@interface MSSharePointClient : MSODataBaseContainer

-(id)initWithUrl : (NSString *)url  dependencyResolver : (id<MSODataDependencyResolver>) resolver;

-(MSSharePointDriveFetcher*) getdrive;

-(MSSharePointItemCollectionFetcher*) getfiles;

@end